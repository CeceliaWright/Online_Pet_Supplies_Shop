# Online_Pet_Supplies_Shop
[Tableau Visualization](https://public.tableau.com/app/profile/cecelia.wright/viz/OnlinePetSuppliesSalesReport/SalesPerformance)

Data analysis of pet supplies sales through an e-commerce platform

## Executive Summary

Using Excel, SQL, and Tableau, I used the  "E-Commerce Pet Supplies Dataset" from an e-commerce platform to complete and exploratory data analysis and visualization dashboard to identify business insights. Based on this analysis, I recommend the business implement a few strategies to increase sales:

1. Phase out underperforming items and focus on top-performing products through marketing and promotion.
2. Implement individualized marketing and promotions when customers add products to their wishlist.
3. Optimize stock levels to remain within optimal ranges.

## Business Problem
The project objectives are to apply data analytics tools to gain useful insights into navigating e-commerce trends, product popularity, and consumer preferences within the pet supply market, as well as to support decision making to optimize inventory management and increase sales efficiency.

Sales:

By analyzing sales distribution, the business can identify underperforming products that are slowing inventory turnover and recognize top-selling products driving revenue, guiding the business in revising the product portfolio and targeted marketing strategies to improve overall sales efficiency and profitability.

Wish List:

The business can use the insights from this project to tailor their marketing strategies and promotional efforts more effectively by prioritizing products with high-sales volumes and frequently wishlisted products in advertising campaigns, special deals, and recommendations. This targeted approach will work to increase customer engagement, driving higher revenue, and support strategic planning in inventory management and sales optimization, addressing key challenges in the competitive e-commerce pet supply market.

Stock:

By analyzing trends in product popularity and consumer preferences, the business can better understand which products are most in demand. This understanding can help in making informed decisions about stock levels to avoid overstocking or stockouts, thus improving inventory turnover rates. 

## Methodology

1. Data cleaning: I categorized products based on keywords, translated non-English entries, and reviewed for accuracy. I parsed 'tradeAmount' to extract numerical values and imputed an outlier in 'quantity' with the median to ensure consistency. This process resulted in a clean, standardized dataset ready for analysis.
2. SQL: I extracted and transformed data from the dataset using a series of SQL queries that computed basic descriptive statistics, analyzed market trends, and examined product ratings and inventory levels. These queries involved aggregations, conditional logic, and window functions to ensure comprehensive data analysis and insightful visualizations.
3. Tableau: I built a dashboard in Tableau to showcase key KPIs, sales trends, and inventory analysis.

## Skills:
* Data cleaning in Excel, Google Sheets, SQL, Google apps scripts
* SQL: Descriptive statistics calculations, advanced aggregations, subqueries and common table expressions (CTEs), data transformation
* Tableau: data visualization, data modeling

## Results & Business Recommendation
**Sales**

Analysis of sales data shows that 82% of products sold fewer than 500 units, signifying slow inventory turnover and underperformance.On the other hand, only 10 products achieved sales in the 10,000+ category, highlighting that a small fraction of products are driving the majority of revenue. 

Business Recommendation:

To improve overall sales, I recommended revising the product portfolio by phasing out underperforming items and concentrating on top-performing products. This strategy includes ensuring appropriate stocking levels for high-demand products and increasing focus on targeted marketing and promotional efforts to maximize their revenue potential.

**Wishlist count and sales amount correlation**

The analysis of the dataset revealed a Pearson correlation coefficient of 0.497 between the variables "amount sold" and "wishlist count." This coefficient indicates a moderate positive correlation, suggesting that as the wishlist count increases, the amount sold also tends to increase. The p-value for this correlation is less than .0001, confirming that the correlation is statistically significant at the 0.05 level.

Business Recommendation:

The statistically significant correlation between wishlist count and sales amount provides valuable insights for strategic business decisions. Specifically, products with high wishlist counts are more likely to experience higher sales. Based on this information, I recommend individualized marketing and promotions for products with high wishlist counts and implementing targeted advertisement strategies for customers who have added items to their wishlist.

**Stock Optimization**

Provided that optimal stock level is 3 times the average sales for any given product, and allowing for a range of ±1 standard deviation to the optimal stock level, 46.15% of products are understocked, and 20.87% are overstocked, with only 32.98% being within an optimal stock range.

Business Recommendation:

Optimizing stock levels so that they remain within optimal ranges will allow for more effective use of storage space. It will decrease the likelihood of items being unavailable and save resources by not overstocking items.

## Limitations

Past the quantity 499, sales amounts were identified by ranges rather than exact sales numbers, for example 5,000+ sold is shown for a product instead of the exact sales amount. This limits the accuracy of any correlations drawn and should be taken into account when developing actionable insights.

## Next Steps

An expanded dataset with exact sales amounts would enable more accurate correlations to be measured. Similarly, time series data would enable a deeper exploration of sales patterns and trends over time. Both of these would result in more targeted actionable insights.

