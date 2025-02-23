# Overview
## Introduction

Welcome to the Amazon Electronics project. This project is designed to analyze and visualize key trends in the electronics sector using data derived from Amazon sales records. In this analysis, we explore the performance of various product categories, identify emerging patterns, and derive actionable insights that can inform strategic decisions.

## Background

The dataset used in this project was originally provided by Ana Potushko on Kaggle and contains over 18,000 rows of data. It represents the top 100 best sellers in the Amazon Electronics category, updated daily from February until July. The raw data underwent thorough cleaning and preprocessing using Python, ensuring consistency and accuracy before further analysis.

## Tools Used

The main tools and technologies utilized in this project include:
- **Python:** Employed for data cleaning, preprocessing, and initial exploration. Libraries such as Pandas, NumPy, and visualization tools like Matplotlib/Seaborn were essential.
- **SQL:** Used to prepare and structure the dataset, allowing efficient data querying and aggregation for further analysis.
- **Power BI:** Utilized to create an interactive dashboard that presents key trends and metrics from the dataset.

## Analysis

Data preparation for the Power BI dashboard involved using SQL to organize and structure the dataset effectively. During the exploratory analysis phase, several key trends and relationships were identified. A pivotal step in this analysis was the addition of the **Frequency in Top** column, which quantifies how frequently a product appears in the top 100 list. This indicator proved crucial in highlighting the most popular and best-selling products within the electronics category.

``` sql
SELECT name, COUNT(*) AS frequency --  Häufigkeit von Produkten analysieren
FROM electronics_data
GROUP BY name
ORDER BY frequency DESC
LIMIT 10;
```

## What You Learned

Through this project, several key lessons were learned:
- **Data Cleaning & Preprocessing:** Improved skills in cleaning and preparing large datasets using Python, ensuring data consistency and accuracy.
- **SQL for Data Structuring:** Learned how to effectively organize and prepare the dataset using SQL, which was essential for subsequent analysis in Power BI.
- **Dashboard Creation:** Gained hands-on experience in creating an interactive Power BI dashboard to dynamically visualize trends and key metrics.
- **Key Performance Indicators:** The addition of the 'Frequency in Top' column emphasized the importance of monitoring recurring success indicators to assess market trends.
- **DAX Code Application:** Applied DAX code to enhance data calculations and derive additional insights in the Power BI dashboard, further boosting the analytical capabilities.

![Interactive 2 page Dashboard, *Screenshot*](https://github.com/chriskorol/Amazon-Top-100-Best-Sellers/blob/main/Dashboard.png)
![Interactive 2 page Dashboard, *Screenshot2*](https://github.com/chriskorol/Amazon-Top-100-Best-Sellers/blob/main/Screenshot%202025-02-23%20at%2020.19.53.png)
## Insights



The analysis provided several key insights:
- **Correlation with Sales:** The frequency of product appearances in the Top 100 list strongly correlates with overall sales performance.
- **Seasonal Trends:** Certain electronics categories show seasonal spikes, suggesting that market demand varies throughout the year.
- **Enhanced Data Transformation:** The integration of SQL and DAX code streamlined data processing, enabling more sophisticated calculations and visualizations in Power BI.
- **Informed Decision-Making:** The interactive dashboard facilitated the rapid identification of market shifts, supporting data-driven strategic decisions.
- **Product Ratings and Searches:** Interestingly, products in the top do not necessarily have an average rating, but they exhibit a high number of searches and user interactions.
- **Price Dynamics:** Observable price changes among top products offer insights into market trends, while products priced below 50 euros tend to be more popular—highlighting potential areas for ABC analysis.
- **Seasonality Hypothesis Testing:** There are clear indicators for seasonal trends. For instance, during the summer period, Kindle eBooks began to sell, and sales may have also increased due to the release of a new book model. This finding prompts further investigation for more detailed information.

# Bonus: Web Scraping

In addition to the primary analysis, a web scraping component was implemented to extract product reviews directly from Amazon. This allows for further analysis of customer sentiment and highlights specific product attributes. The code snippet below demonstrates how libraries such as `requests`, `BeautifulSoup`, `nltk`, and `WordCloud` were used to gather review data, filter adjectives, and generate word clouds for enhanced visual insights.

```python
# Web Scrapping

# import libraries 
import requests
from bs4 import BeautifulSoup
from wordcloud import WordCloud, STOPWORDS
from PIL import Image  # to load our image
import nltk
from nltk.corpus import stopwords as nltk_stopwords
from nltk.tokenize import word_tokenize
from nltk import pos_tag
import numpy as np
import matplotlib.pyplot as plt

# Download Stopwords
nltk.download('punkt')
nltk.download('averaged_perceptron_tagger')
nltk.download('stopwords')

# Function to get reviews from Amazon
def get_reviews(url):
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
        "Accept-Encoding": "gzip, deflate",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "DNT": "1",
        "Connection": "close",
        "Upgrade-Insecure-Requests": "1"
    }
    page = requests.get(url, headers=headers)
    soup = BeautifulSoup(page.content, "html.parser")
    reviews = soup.find_all("span", {"data-hook": "review-body"})
    return " ".join([review.get_text().strip() for review in reviews])

# Filter only adjectives
def filter_adjectives(text):
    words = word_tokenize(text.lower())  
    tagged_words = pos_tag(words)  
    adjectives = [word for word, tag in tagged_words if tag.startswith("JJ")]  
    return " ".join(adjectives)

# URLs for three products
urls = [
    'https://www.amazon.com/Blink-Mini-Black-3Cam/dp/B09Y52VM8W/ref=sr_1_1?crid=FS0WJBH9O8EW&dib=eyJ2IjoiMSJ9.9_iuKsd4_OZRC98iI56YpP0HTymvD4Bbc6kN1CIEsRgIEzdsZ7apOFCufma1SeVSw_IfHyjCWWZUXQA4qgUlDuO50s4IXXRyAG1-333MZ68zvr3Bw2ri6hYP4OfnTkn4ezdujvk9pjnPKcK_58NYscJPSjqqXyXQRESvtoaXb6wNheJ33R8SwYDlsUC8aL62_9rSky8NtUb22fkykU1FBe-PeQ74ktukkiCK1YLFAjQ.HZVkVoLzk9ZL2AHkbdsc-G6R5nwWT6vov9Rarqpgrek&dib_tag=se&keywords=Blink%2BMini%2B%E2%80%93%2BCompact%2Bindoor%2Bplug-in%2Bsmart%2Bsecurity%2Bcamera%2C%2B1080%2BHD%2Bvideo%2C%2Bnight%2Bvision%2C%2Bmotion%2Bdetection%2C%2Btwo-way%2Baudio%E2%80%A6&qid=1736177182&sprefix=blink%2Bmini%2Bcompact%2Bindoor%2Bplug-in%2Bsmart%2Bsecurity%2Bcamera%2C%2B1080%2Bhd%2Bvideo%2C%2Bnight%2Bvision%2C%2Bmotion%2Bdetection%2C%2Btwo-way%2Baudio%2B%2Caps%2C170&sr=8-1&th=1',
    'https://www.amazon.com/Blink-Outdoor-4th-Gen-Mini/dp/B0BWFFQZ7G/ref=sr_1_1?crid=3G0S8SY75IEF0&dib=eyJ2IjoiMSJ9.CkaYNVLkHaIWu13AnnwrDY8YMMh8wCaJuGvyKUdoZ0KauQVf7ef1UQo0yrZCXkumW3WLsryLCmM31qjSYsI0GG-jLETGn6QygHoi3GEraAJkEla_T2iGEjLfdT9FYOougpsMs55umF-lfFIqRmj9FroyBMAzSuOSY0De_1aCOjO9BSPhR10RfIDUMmkmD4WvMSdxvcD39a5emOx8qGXU1alp_6BWeuvLGKdX8yZTMLo.VFOs61yyfrHKUF5FMESu-6U1EpF0k5pTUkjHJN6kauE&dib_tag=se&keywords=Blink+Outdoor+-+wireless%2C+weather-resistant+HD+security+camera%2C+two-year+battery+life%2C+motion+detection%2C+set+up+in%E2%80%A6&qid=1736187152&sprefix=blink+outdoor+-+wireless%2C+weather-resistant+hd+security+camera%2C+two-year+battery+life%2C+motion+detection%2C+set+up+in+%2Caps%2C191&sr=8-1',
    'https://www.amazon.com/All-new-Amazon-Kindle-Paperwhite-glare-free/dp/B0DDZJS3SB/ref=sr_1_1?crid=2NYNQC5OVN33G&dib=eyJ2IjoiMSJ9.cDU_PrEjLn2SWNxvTBIf4DJy3MR3tQqcD2tWeNBBTDgXCVs6ONNUZW-ZxkXV44jdTlKJPOAln4jzHW18fy6lFS_ryeU5i30KTWaR1nJUvyXdxX6VcumbxmHEYI55PmT4TDFY5NZD4lAN9FPjMD6iQvVD_jehTjY3sctKDBCPC52gIVKFSAaq5WknNf0CyN0f.tzHwQgAC1tG2u3KnUv1LjmURmf_38rAGt4J9aGI_h5E&dib_tag=se&keywords=Kindle+Paperwhite+%E2%80%93+Now+Waterproof+with+2x+the+Storage+%E2%80%93+Ad-Supported&qid=1736187755&sprefix=kindle+paperwhite+now+waterproof+with+2x+the+storage+ad-supported%2Caps%2C440&sr=8-1'
]

# Generate a Word Cloud for each product
for i, url in enumerate(urls):
    reviews_text = get_reviews(url)
    adjectives_text = filter_adjectives(reviews_text)
    stopwords_combined = set(STOPWORDS)
    wordcloud = WordCloud(width=800, height=400, background_color='white').generate(adjectives_text)
    # Display the word cloud for each product
    plt.figure(figsize=(10, 5))
    plt.imshow(wordcloud, interpolation='bilinear')
    plt.axis('off')
    plt.show()

# Appearance-related Word Cloud using a custom mask
custom_mask = np.array(Image.open('D:/THWS/BI/the_best_cloud.jpg'))
wc = WordCloud(background_color='white',
               stopwords=STOPWORDS,
               mask=custom_mask)
wc.generate(adjectives_text)

plt.figure(figsize=(10, 5))
plt.imshow(wc, interpolation='bilinear')
plt.axis('off')
plt.show()

```

![One of three WordClouds](https://github.com/chriskorol/Amazon-Top-100-Best-Sellers/blob/main/Business%20Presentation.png)

## Conclusion

This project demonstrates a robust approach to data analysis and visualization by integrating multiple tools and techniques. Using Python for data cleaning, SQL for data structuring, and DAX with Power BI for advanced calculations and interactive dashboards, valuable insights were uncovered regarding Amazon's electronics market. These insights include seasonal trends, dynamic pricing changes, and the impact of high search volumes on product performance—even when average ratings are not high. Additionally, products priced under 50 euros tend to perform better, suggesting potential for further ABC analysis. The project also lays the groundwork for testing seasonal hypotheses, such as the rise in Kindle eBook sales during the summer and the influence of new book models on overall sales. Overall, the project sets the stage for continuous, data-driven decision-making and further investigative analysis.

