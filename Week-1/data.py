import yfinance as yf
import pandas as pd
import plotly.express as px
import plotly.io as pio
from datetime import datetime, timedelta

# assets that we are gonna be watching
tickers = ['^NSEI','^BSESN','GLD','RELIANCE.NS','^NSEBANK']

# prices till today
end_date = datetime.today()

# prices from 5 years ago
start_date = end_date - timedelta(days = 5*365)

# dataframe to store the closing prices of each day
close_df = pd.DataFrame()

# building the dataframe
for ticker in tickers:
    data = yf.download(ticker,start = start_date, end = end_date)
    close_df[ticker] = data['Close']

# fixing missing values
close_df = close_df.ffill().dropna()

# dataframe to normalize the prices and makes every asset start at 100
price_df = close_df/close_df.iloc[0] * 100

# plotting data using plotly
fig = px.line(
    price_df,
    x=price_df.index,
    y=price_df.columns,
    title = 'Normalized Comparison'
)

# saves the plot
pio.write_image(fig,'./Week-1/data.png')
# shows the plot in a browser window - check it out!!
fig.show()