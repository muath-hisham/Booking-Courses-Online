import nltk # Natural Language Toolkit
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
import numpy as np

def preprocess(text):
    # Tokenize text into sentences 
    sentences = sent_tokenize(text)

    # Tokenize each sentence into words and remove stopwords
    stop_words = set(stopwords.words('english'))
    words = []
    for sentence in sentences:
        words.extend([word for word in word_tokenize(sentence) if word.lower() not in stop_words])

    # Stem words using Porter stemmer
    stemmer = PorterStemmer()
    stemmed_words = [stemmer.stem(word) for word in words]

    return stemmed_words, sentences

def build_graph(words, window_size=2):
    # Create a graph with nodes as words and edges between co-occurring words within a sliding window
    graph = {}
    for i in range(len(words)):
        for j in range(i+1, min(i+window_size+1, len(words))):
            if words[i] not in graph:
                graph[words[i]] = {}
            if words[j] not in graph[words[i]]:
                graph[words[i]][words[j]] = 0
            graph[words[i]][words[j]] += 1
            if words[j] not in graph:
                graph[words[j]] = {}
            if words[i] not in graph[words[j]]:
                graph[words[j]][words[i]] = 0
            graph[words[j]][words[i]] += 1

    # Normalize edge weights by dividing by the maximum weight in the graph
    max_weight = max([graph[u][v] for u in graph for v in graph[u]])
    for u in graph:
        for v in graph[u]:
            graph[u][v] /= max_weight

    return graph

def compute_page_rank(graph, damping_factor=0.85, epsilon=1e-4, max_iterations=100):
    # Initialize PageRank scores
    page_rank = {node: 1/len(graph) for node in graph}

    # Iteratively update PageRank scores until convergence or maximum number of iterations is reached
    for iteration in range(max_iterations):
        new_page_rank = {}
        for node in graph:
            # Compute the sum of incoming edge weights
            incoming_weights = sum([graph[v][node] * page_rank[v] for v in graph[node]])

            # Update the PageRank score for the current node
            new_page_rank[node] = (1 - damping_factor) / len(graph) + damping_factor * incoming_weights

        # Check for convergence
        if sum([abs(new_page_rank[node] - page_rank[node]) for node in graph]) < epsilon:
            break

        page_rank = new_page_rank

    return page_rank

def summarize(text, ratio=0.25):
    # Preprocess the text (remove the noise from the text and Sentence splitting)
    words, sentences = preprocess(text)

    # Build the word co-occurrence graph
    graph = build_graph(words)

    # Compute the PageRank scores
    page_rank = compute_page_rank(graph)

    # Sort the nodes by their PageRank scores
    ranked_nodes = sorted(page_rank, key=page_rank.get, reverse=True)

    # calculate num_sentences
    num_sentences = int(len(sentences) * ratio)
    if(num_sentences == 0):
        num_sentences = 1;
    # print(num_sentences)

    # Get the top-ranked sentences
    summary = []
    for node in ranked_nodes:
        for sentence in sentences:
            if node in word_tokenize(sentence) and sentence not in summary:
                summary.append(sentence)
                if len(summary) == num_sentences:
                    break
        if len(summary) == num_sentences:
            break

    return " ".join(summary)

