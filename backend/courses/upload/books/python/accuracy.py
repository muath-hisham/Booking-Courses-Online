
from PyPDF2 import PdfReader
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# Define reference summaries
reader_my_summ = PdfReader('my_summ.pdf')
my_summ = ""
for page in reader_my_summ.pages:
    text_summ = page.extract_text()
    my_summ += text_summ
    my_summ += "\n\n"
    
    
# Define textRank summaries
reader_textRank = PdfReader('output.pdf')
textRank_summ = ""
for page in reader_textRank.pages:
    text_textRank = page.extract_text()
    textRank_summ += text_textRank
    textRank_summ += "\n\n"

# initialize the TF-IDF vectorizer
vectorizer = TfidfVectorizer()

# fit the vectorizer to the summary texts
vectors = vectorizer.fit_transform([textRank_summ, my_summ])

# calculate the cosine similarity between the two vectors
similarity = cosine_similarity(vectors[0], vectors[1])

# print the similarity score
print("Accuracy:", similarity[0][0])