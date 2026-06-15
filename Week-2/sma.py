import yfinance as yf
import numpy as np
import pandas as pd
import plotly.express as px
import plotly.io as pio
from datetime import datetime,timedelta


# Settings
security = '^NSEI'
end_date = datetime.today()
start_date = end_date - timedelta(1000)
fsma_period = 10
ssma_period = 100


# Collecting data
data = yf.download(security,start=start_date,end=end_date)
df = pd.DataFrame(data)
df.columns = df.columns.get_level_values(0)


# Calculating fast sma and slow sma
df['Fast_sma'] = df['Close'].rolling(fsma_period).mean()
df['Slow_sma'] = df['Close'].rolling(ssma_period).mean()


# Finding crossovers
df['Prev_fsma'] = df['Fast_sma'].shift(1)
df['Prev_ssma'] = df['Slow_sma'].shift(1)
df.dropna(inplace = True)

def find_crossover(prev_fsma, prev_ssma, fsma, ssma):
    if fsma > ssma and prev_fsma <= prev_ssma:
        return 'Bullish Crossover'
    elif fsma < ssma and prev_fsma >= prev_ssma:
        return 'Bearish Crossover'
    return None

df['Crossover'] = np.vectorize(find_crossover)(df['Prev_fsma'],df['Prev_ssma'],df['Fast_sma'],df['Slow_sma'])

signal_buy = df[df['Crossover'] == 'Bullish Crossover'].copy()
signal_sell = df[df['Crossover'] == 'Bearish Crossover'].copy()


# Plotting prices
prices = px.line(
    df,
    x = df.index,
    y = ['Close','Fast_sma','Slow_sma'],
    title = 'Prices and SMAs'
)
pio.write_image(prices,'PricesAndSMAs.png')
prices.show()


# Plotting buy and sell positions
prices.add_scatter(
    x = signal_buy.index,
    y = signal_buy['Close'],
    mode = 'markers',
    marker = dict(color = 'green', size = 12, symbol = 'triangle-up'),
    name = 'Buy'
)
prices.add_scatter(
    x = signal_sell.index,
    y = signal_sell['Close'],
    mode = 'markers',
    marker = dict(color = 'red', size = 12, symbol = 'triangle-down'),
    name = 'Sell'
)
pio.write_image(prices,'Positions.png')
prices.show()