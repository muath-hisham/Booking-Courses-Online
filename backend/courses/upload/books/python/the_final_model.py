
# pip install PyPDF2
# pip install fpdf
# pip install summa

# importing required modules
from PyPDF2 import PdfReader
from fpdf import FPDF
from textRank import *
import os
# from summa import summarizer

def textRankSumm(fileName):
    if os.path.exists("C:\\xampp\\htdocs\\courses\\upload\\books\\before\\" + fileName):

        # creating a pdf reader object
        reader = PdfReader("C:\\xampp\\htdocs\\courses\\upload\\books\\before\\" + fileName)

        # printing number of pages in pdf file
        print("number of pages before summarize is: ")
        print(len(reader.pages))
        before = len(reader.pages)
        # getting a specific page from the pdf file
        # page = reader.pages[8]

        pdf = FPDF()
        font_file_path = "C:\\xampp\\htdocs\\courses\\upload\\books\\python\\Calibri.ttf"
        if os.path.exists(font_file_path):
            pdf.add_font('Calibri', '', font_file_path, uni=True)
            print("added sucsess")
        else:
            print(f"{font_file_path} does not exist")

        pdf.add_page()
        pdf.set_font('Calibri', '', 15) # for paragraph txt
        print("using sucsess")

        # start = 7   # 7
        # end = 30 # 30
        # # txt = ""
        # x = 0 # to know what is the current page

        # TextRank is not a machine learning model and does not have an accuracy score.
        # the classification accuracy of TextRank algorithm is 94% when the number of keywords is 40. 

        for page in reader.pages:
            # x += 1
            # if (x < start or x > end):
            #     continue
            try:
                text = page.extract_text()
                paragraphs = text.split('\n\n')
                for paragraph in paragraphs:
                    if len(paragraph) > 50:
                        # summ = summarizer.summarize(paragraph, ratio=0.5)
                        summ = summarize(paragraph, ratio=0.4)
                        pdf.write(8,summ)
                        pdf.write(8,"\n\n")
                    else:
                        pdf.write(8,paragraph)
                        pdf.write(8,"\n\n")
            except:
                print("error")


        # Specify the file path for the output PDF
        output_path = "C:\\xampp\\htdocs\\courses\\upload\\books\\after\\" + fileName

        pdf.output(output_path)
        
        print("output sucsess")
        # to print the number op pages after summarize
        output = PdfReader(output_path)
        print("number of pages after summarize is: ")
        print(len(output.pages))
        after = len(output.pages)

        return {"before": before, "after": after}
    else:
        print("File does not exist")