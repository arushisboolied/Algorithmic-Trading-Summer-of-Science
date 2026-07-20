#import "@preview/tapestry:0.0.4": *
#show: tapestry.with(
  title: "Final Report",
  year: "2026",
)

#set text(size: 11pt)
#let accentgray = rgb("#595959")

#align(center)[
  #text(size: 17pt, weight: "bold")[Reading Notes]

  #text(size: 13pt, style: "italic")[Quantitative Trading: How to Build Your Own Algorithmic Trading Business]

  Ernest P. Chan #text(fill: accentgray)[(2nd ed., 2021)]

  Chapters 1--3
]

#outline(title: "Contents")

#line(length: 100%, stroke: accentgray)

= The Whats, Whos, and Whys of Quantitative Trading

Chan opens by clearing up a misconception that often hangs around the term. Quantitative trading (sometimes called algorithmic trading) is simply the practice of making buy and sell decisions through computer algorithms that the trader designs, tests on historical data, and then runs live. It is not synonymous with technical analysis, though it can incorporate it. Nor is it restricted to esoteric instruments: the kind Chan advocates is statistical arbitrage on stocks, futures, and currencies, things any reasonably numerate person can engage with without a PhD in stochastic calculus.

Who belongs in the room, then? Chan's answer is deliberately inclusive. His own route was conventional, a Cornell physics doctorate, IBM research, a string of investment banks, but many of the independent traders he knows came from software development, exchange floors, biochemistry, or architecture. The common thread is not a credential but a disposition: some prior exposure to how markets work, enough savings that early losses are survivable, and an emotional register that sits comfortably between reckless confidence and paralysing fear. Crucially, he notes that his own most profitable strategies emerged not from the sophisticated techniques he deployed at Morgan Stanley and Credit Suisse, but from the simplest quantitative ideas he eventually tried from a spare bedroom. The Einstein aphorism he quotes, "make everything as simple as possible, but not simpler", is less a cliché here than a thesis statement for the book.

The business case for going independent rests on three structural advantages. The first is scalability: increasing position size often means changing a single number in a program rather than hiring staff or pitching to a bank. With a proprietary trading firm, a \$50,000 equity stake can control a \$2 million intraday portfolio; futures and currency trading offer similar leverage through ordinary retail brokers. The second advantage is time. Quantitative trading at full automation approaches zero daily operational overhead; Chan describes colleagues who came into the office once a month. His own early routine consumed two hours before the open and half an hour near the close, and that burden shrank as automation improved. The third is the near-total absence of marketing. Because counterparties in financial markets are indifferent to everything except price, a trader managing only her own capital has no customers to cultivate, no reputation to perform. The product and the strategy are the same thing.

This last point carries a small but important caveat. Chan is explicit that quantitative trading is not a path to overnight wealth; the leveraged returns possible through a high Sharpe ratio strategy accumulate steadily rather than explosively. The aspiration is a growing, sustainable income stream, not a windfall.

= Fishing for Ideas

The surprise of this chapter is stated plainly at the outset: finding a trading idea is not the hard part. Academic finance journals, business school working-paper repositories (SSRN, NBER), quantitative blogs, trader forums, and social media between them generate a continuous supply of candidate strategies, most of them described in enough detail to attempt replication. Chan keeps a table of sources he finds valuable, Quantpedia, Elite Trader, Flirting with Models, various Twitter accounts, and notes that the public availability of these ideas does not trivially destroy their value, because most people sharing them have not tested the variants that actually work.

The harder task is developing what Chan calls a "taste" for strategies, an ability to pre-filter candidates against your personal circumstances before spending weeks backtesting something that was never going to suit you. He organises this filtering around four personal axes.

_Working hours_ matter because strategies differ in the attention they demand. Someone with a day job should probably stick to end-of-day signals that can be entered as a batch of limit orders before the open, rather than anything requiring intraday monitoring. Full automation can partially substitute for attention, but only once the system has been built and proven stable.

_Programming skill_ determines how many securities you can practically trade at once and whether high-frequency strategies are within reach. A confident Visual Basic or Python user can explore much larger strategy spaces than someone whose ceiling is Excel formulas, though Chan is at pains to point out that many excellent strategies live well within Excel's reach.

_Capital_ imposes a web of constraints that Chan maps out honestly. Below roughly \$50,000, the options narrow significantly: commissions become proportionally heavier, survivorship-bias-free data may be unaffordable, and many futures contracts are simply too large to manage prudently. Capital also determines whether dollar-neutral (long--short) strategies are practical. A dollar-neutral book requires twice the margin of a directional one but carries less market risk; the right choice depends on how much leverage is available and at what cost.

_Goal_ shapes the preferred holding period. A trader who needs monthly income should choose strategies with high turnover and consequently smoother return distributions. Someone optimising for long-run compounding should seek the highest Sharpe ratio achievable, because, counterintuitively, a high-Sharpe, low-nominal-return strategy run at sufficient leverage outgrows a low-Sharpe, high-nominal-return strategy over time. The buy-and-hold intuition that long horizons reward patience is, Chan argues, mathematically incorrect once leverage is available.

Beyond personal fit, Chan offers a set of red flags to apply before backtesting. Does the strategy outperform a sensible benchmark? A long-only strategy returning 10% annually in equities is unremarkable; a dollar-neutral one returning 10% against a near-zero risk-free rate is genuinely interesting. Is the reported Sharpe ratio, or the equity curve's visual texture, consistent with claims of reliability? Deep or protracted drawdowns are almost always incompatible with a high Sharpe ratio. Have transaction costs been accounted for? Chan gives the example of a Bollinger-Band mean-reversion strategy on E-mini S&P 500 futures that showed a Sharpe of 3 before costs and $-3$ after a single basis point of friction per trade. Does the data suffer from survivorship bias, the exclusion of stocks that later went bankrupt or were delisted? Has the strategy decayed in more recent years, suggesting either crowding or a structural market change? And does it occupy a niche, low capacity, infrequent signals, unusual instruments, that institutional money cannot easily enter?

The chapter closes with a sidebar on artificial intelligence and stock picking that is worth noting. Chan was sceptical of ML applied directly to market prediction in 2009, and remains so in the second edition, not because the techniques have not improved, but because the problem structure is hostile to them. The number of statistically independent observations in financial time series is far smaller than in consumer transactions or image libraries, making overfitting almost inevitable. His recommended application of ML is "metalabeling": using it to estimate the probability that your own private trading signal will be profitable on a given day, rather than predicting the market directly. This way you avoid competing with everyone else trying to extract signal from the same public price series.

= Backtesting

Backtesting, running a strategy against historical data to evaluate how it would have performed, is where the quality of an idea is first seriously tested, and where most errors are made. Chan structures the chapter around four topics: the available platforms, the historical data sources and their quirks, the performance metrics that matter, and the pitfalls that produce misleadingly good results.

== Platforms

Chan surveys the main options with a degree of candour unusual in books aimed at practitioners. Excel is his starting point: visible, auditable, resistant to certain subtle errors (look-ahead bias is hard to commit accidentally in a spreadsheet), and capable of handling a surprising range of strategies. MATLAB is his personal preference for heavier work, faster than Python for numerical loops, backed by professional support, and equipped with statistics and econometrics toolboxes that Chan considers superior to their Python equivalents. He is forthright about Python's weaknesses: version conflicts that consume hours even from experienced developers, performance that academic benchmarks place well below MATLAB, no vendor support, and statistics packages he finds inferior to R's. None of this prevents him from providing full Python and R code for every example; he simply does not pretend the language is without cost. QuantConnect and Blueshift round out the survey as web-based platforms that handle data, backtesting, and live execution in a single environment, reducing the risk that the live system subtly differs from the backtested one.

== Historical data

Getting the data right is unglamorous but critical. Two issues dominate. The first is split and dividend adjustment. When a stock splits two-for-one, all historical prices must be halved; when a dividend is paid, all prior prices must be scaled by the ratio of the pre-dividend close to the post-dividend close. Chan walks through the arithmetic in detail using IGE as an example, showing how cumulative multipliers from multiple dividend events compound. Failing to adjust correctly produces spurious signals, a sudden apparent price drop that the algorithm interprets as a trading opportunity when it is actually a data artefact.

The second issue is survivorship bias. A database that contains only stocks still trading today is missing every company that went bankrupt, was acquired, or was delisted between then and now. Because cheap stocks that survive tend to survive precisely because they recovered, backtesting a "buy cheap stocks" strategy on survivorship-biased data produces grotesquely inflated returns. Chan illustrates this with a toy portfolio: the ten lowest-priced large-cap stocks at the start of 2001, selected from a survivorship-biased database, returned 388% over the year; the same selection from a complete database returned $-42%$. The difference is nine stocks that went to near zero and were silently omitted.

A third, subtler issue is the reliability of intraday high and low prices. Because the recorded high of a day may reflect a single small transaction or a data error, limit orders placed at that level in a backtest often cannot be assumed to have actually filled. Strategies that depend on high/low data for entry and exit signals are systematically more optimistic in backtest than in live trading.

== Performance measurement

The primary metric is the Sharpe ratio, the annualised mean excess return divided by the annualised standard deviation of those excess returns:

$ S = mu_e / sigma_e, quad mu_e = 252 macron(r)_e, quad sigma_e = sqrt(252) hat(sigma)_e, $

where $macron(r)_e$ is the sample mean of daily excess returns and $hat(sigma)_e$ is their sample standard deviation. Chan is methodical about the details that practitioners often fudge: what counts as the risk-free rate (essentially zero at time of writing, but matters for comparison), how to annualise correctly from daily data (multiply the mean by 252 and the standard deviation by $sqrt(252)$), and when to use the information ratio instead, defined as

$ "IR" = (mu_p - mu_b) / sigma_(p-b), $

where $mu_p$ and $mu_b$ are the annualised returns of the portfolio and benchmark respectively and $sigma_(p-b)$ is the annualised standard deviation of the active return $r_p - r_b$, when benchmarking a long-only strategy against a market index rather than a risk-free rate. As a rough guide: a Sharpe below 1 is hard to justify as a standalone strategy; above 2 suggests profitability in most months; above 3 suggests profitability in most days.

Drawdown is the companion metric. If $V(t)$ denotes the equity curve, define the running peak $M(t) = max_(s <= t) V(s)$; the drawdown at time $t$ is then

$ D(t) = (M(t) - V(t)) / M(t). $

The maximum drawdown is $"MDD" = max_t D(t)$, the largest peak-to-trough decline in cumulative equity; the maximum drawdown duration is the longest interval $[t_1, t_2]$ such that $V(t) < M(t_1)$ for all $t in (t_1, t_2]$. Chan treats these not as abstract statistics but as personal psychological thresholds: the question is not what the numbers are but whether you can survive them without abandoning the strategy at the worst moment. A strategy whose maximum drawdown exceeds your temperament's tolerance is not a good strategy for you, regardless of its long-run expectation.

== Pitfalls

Look-ahead bias, inadvertently using future information to generate a past signal, is the most dangerous error because it is invisible in the code and produces spectacular backtest results. The classic form is using the closing price to generate a signal and then assuming execution at that same close, when in practice the signal cannot be computed until after the market shuts. Chan recommends careful attention to the timing convention: signals computed from day $t$ data should only generate orders executable on day $t+1$ or later.

Data-snooping bias, also called overfitting, arises from optimising strategy parameters on the same data used to evaluate the strategy. Even with only one or two parameters, say, a moving average lookback and an entry threshold, there are enough degrees of freedom to fit historical accidents that will not repeat. Chan discusses several mitigation approaches: out-of-sample testing, walk-forward validation, and the Deflated Sharpe Ratio, a correction that accounts for the number of parameter combinations tried. His practical heuristic is simply to prefer fewer parameters and more transparent logic. Models that require elaborate justification for each parameter choice are usually fitting noise.

Transaction costs require more careful treatment than most published research provides. Commission is the smallest component; bid--ask spread, market impact from large orders, and execution slippage from internet latency and software delays all compound on top of it. The Bollinger-Band example from Chapter 2 returns here: a strategy that looked attractive before costs was deeply unprofitable after a single basis point of friction per trade. Chan recommends computing the Sharpe ratio net of realistic transaction cost estimates before ever considering a strategy live-tradable.

The chapter ends with a note on strategy refinement. A candidate strategy pulled from a forum or paper is rarely the final product. Shortening the holding period, changing entry and exit timing, applying the idea to a different instrument or universe, small modifications can turn an unpromising backtest into a primary profit centre. Chan gives a personal example of doing exactly this with a strategy suggested by a blog reader, demonstrating that the creative work in quantitative trading is often not finding the original idea but finding the variation that actually survives contact with real costs and real data.

= Coding Project

Applied the learnings from these chapters by building a small suite of Python backtesting tools, progressing from simple exploratory data work toward a modular, class-based backtesting engine. The project focuses on implementing the complete research workflow discussed by Chan: pulling and cleaning historical price data, generating trading signals, simulating trade execution, and measuring performance through historical backtesting.

The repository is available at:

#align(center)[#link("https://github.com/arushisboolied/Algorithmic-Trading")]

== Week 1 --- Data Collection and Normalization

The first step was simply getting clean, comparable price series for a handful of Indian-market assets, the Nifty 50 and Sensex indices, gold, Reliance Industries, and the Nifty Bank index, pulled via `yfinance` and rebased to a common starting value of 100 so that relative performance could be read directly off the chart.

```python
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
```

#figure(
  image("images/week1_data.png", width: 85%),
  caption: [Normalized five-year price comparison across the Nifty 50, Sensex, gold, Reliance, and the Nifty Bank index, each rebased to 100 at the start of the window.],
)

== Week 2 --- A Simple SMA Crossover Strategy

The second week turned the Week 1 data pipeline into an actual signal: a fast/slow simple-moving-average (SMA) crossover on the Nifty 50, with a 10-day SMA as the fast average and a 100-day SMA as the slow one. A bullish crossover (fast SMA moving above the slow SMA) is flagged as a buy signal, and a bearish crossover (fast SMA moving below the slow SMA) as a sell signal, using `numpy.vectorize` to apply the crossover test row by row.

```python
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

df['Crossover'] = np.vectorize(find_crossover)(
    df['Prev_fsma'], df['Prev_ssma'], df['Fast_sma'], df['Slow_sma']
)

signal_buy = df[df['Crossover'] == 'Bullish Crossover'].copy()
signal_sell = df[df['Crossover'] == 'Bearish Crossover'].copy()
```

#figure(
  image("images/week2_prices_smas.png", width: 85%),
  caption: [Nifty 50 closing price with the 10-day and 100-day SMAs overlaid.],
)

#figure(
  image("images/week2_positions.png", width: 85%),
  caption: [The same chart annotated with buy (green, upward triangle) and sell (red, downward triangle) markers wherever a crossover fires.],
)

== Weeks 3--4 --- A Modular Backtesting Engine

The final stage of the project rebuilt the Week 2 script as a proper, reusable backtester, splitting the pipeline into four cooperating classes: `Data` for fetching and cleaning prices, `SMA` for signal generation, `Portfolio` for simulating trade execution against those signals, and `PerformanceMetrics` for scoring the resulting equity curve. A thin `Backtester` class and a `config.py` settings file tie the pieces together, so that changing the ticker, SMA windows, commission rate, or capital base is a one-line edit rather than a rewrite.

```python
# config.py
INITIAL_CAPITAL = 100000

SHORT_WINDOW = 10
LONG_WINDOW = 100

TICKER = 'RELIANCE.NS'
START_DATE = '2022-01-01'
END_DATE = '2026-01-01'

RISK_FREE_RATE = 0.04
COMMISSION = 0.001
```

The signal logic itself is a direct generalisation of Week 2's crossover test, now expressed as the sign of the difference between the short and long SMAs, with `diff().clip(-1, 1)` picking out only the instants where that sign actually flips:

```python
# src/strategy.py
class SMA:
    def __init__(self, short_window: int = 10, long_window: int = 100):
        self.short_window = short_window
        self.long_window = long_window

    def compute_sma(self, df):
        df = df.copy()
        df[f"SMA_{self.short_window}"] = df['Close'].rolling(window=self.short_window).mean()
        df[f"SMA_{self.long_window}"] = df['Close'].rolling(window=self.long_window).mean()
        return df

    def generate_signal(self, df):
        df = self.compute_sma(df)
        short_col = f"SMA_{self.short_window}"
        long_col = f"SMA_{self.long_window}"

        raw = pd.Series(0, index=df.index)
        raw[df[short_col] > df[long_col]] = 1
        raw[df[short_col] < df[long_col]] = -1

        df["Signal"] = raw.diff().clip(-1, 1)
        return df
```

`Portfolio.apply_signals` is where Chan's backtesting warnings from Chapter 3 are put into practice directly: trades execute on the *next* day's open rather than the signal day's close (avoiding look-ahead bias), and every buy and sell is charged a proportional commission before cash and holdings are updated:

```python
# src/portfolio.py (execution loop)
df['Trade'] = df['Signal'].shift(1).fillna(0)

for i in range(1, n):
    signal = df['Trade'].iloc[i]
    open_price = df["Open"].iloc[i]
    prev_pos, prev_cash = position[i - 1], cash[i - 1]

    if signal == 1 and prev_pos == 0:            # BUY
        shares = prev_cash // open_price
        cost = shares * open_price
        fee = cost * self.commission
        position[i] = shares
        cash[i] = prev_cash - cost - fee

    elif signal == -1 and prev_pos > 0:           # SELL
        proceeds = prev_pos * open_price
        fee = proceeds * self.commission
        position[i] = 0
        cash[i] = prev_cash + proceeds - fee

    else:                                          # HOLD
        position[i] = prev_pos
        cash[i] = prev_cash

df["Holdings"] = df["Position"] * df["Close"]
df["Total"] = df["Cash"] + df["Holdings"]
```

`PerformanceMetrics` then reduces the resulting equity curve and trade log to exactly the numbers Chan's Backtesting chapter flags as essential: total and annualised return, the Sharpe ratio (net of a configurable risk-free rate), maximum drawdown, win rate, and profit factor.

```python
# src/metrics.py (summary)
@classmethod
def summary_report(cls, equity_curve, trade_history):
    return {
        "Total Return (%)": round(cls.total_return(equity_curve), 2),
        "Annualised Return (%)": round(cls.annualised_return(equity_curve), 2),
        "Sharpe Ratio": round(cls.sharpe_ratio(equity_curve), 3),
        "Max Drawdown (%)": round(cls.max_drawdown(equity_curve), 2),
        "Win Rate (%)": round(cls.win_rate(trade_history), 1),
        "Profit Factor": round(cls.profit_factor(trade_history), 2),
        "Total Trades": len([t for t in trade_history if t["action"] == "BUY"]),
    }
```

Running `main.py` fetches Reliance Industries data, generates signals, simulates the portfolio, prints this summary report to the console, and produces an interactive two-panel Plotly chart (price and SMAs with buy/sell markers on top, the equity curve against a dashed initial-capital baseline below) via `Backtester.plot()`. The engine's modularity is the point: the same four classes work unchanged for a different ticker, a different SMA pair, or a different commission schedule, which is exactly the kind of transparent, low-parameter design Chan recommends over elaborate curve-fitted logic.

#v(1em)
#line(length: 100%, stroke: accentgray)
#text(
  size: 9pt,
  fill: accentgray,
)[Source: Chan, Ernest P. _Quantitative Trading: How to Build Your Own Algorithmic Trading Business_, 2nd ed. Wiley, 2021.]


#pagebreak()

= Reading Notes: Algorithmic and High-Frequency Trading

#align(center)[
  #text(size: 13pt, style: "italic")[Algorithmic and High-Frequency Trading]

  Álvaro Cartea, Sebastián Jaimungal \& José Penalva #text(fill: accentgray)[(2015)]

  Chapters 1, 2, 5, 10
]

#line(length: 100%, stroke: accentgray)

== Week 4, Electronic Markets and the Limit Order Book (Ch. 1)

Cartea, Jaimungal and Penalva open the book by insisting that before you can design an algorithm you need to understand the plumbing it will run through. Chapter 1 is essentially an inventory of what gets traded, who trades it, and how an exchange actually processes an order once it arrives.

The "what" is a short tour of instrument types: ordinary shares (claims on a corporation's profits and voting rights), bonds (fixed income with no voting rights, senior to equity in liquidation), preferred stock (a hybrid that behaves like equity legally but pays like debt), and the pooled vehicles built on top of them, mutual funds, ETFs, and hedge funds. The authors draw out a distinction I hadn't thought carefully about before: closed-end funds issue a fixed number of shares once, at IPO, and thereafter trade purely on secondary-market supply and demand, so they can and do drift away from net asset value; open-end funds create and destroy shares daily against NAV; and ETFs sit somewhere in between, using large "creation units" (up to 50,000 shares at a time) that authorized participants break up and resell, which is what keeps an ETF's price tethered to its underlying basket.

The "who" is organized into three archetypes that recur for the rest of the book: fundamental (or noise/liquidity) traders, who trade for reasons outside the market itself, rebalancing, hedging a business exposure, a sudden need for cash; informed traders, who trade because they believe they know something about future prices that isn't yet reflected in them; and market makers, professional intermediaries who profit from facilitating other people's trades rather than from taking a directional view. The authors are careful to note that this taxonomy is about behaviour, not identity, a "fundamental" pension fund rebalancing on a schedule looks like noise to a high-frequency algorithm, but the same fund trading on advance knowledge of a large position change would count as informed. And market making is not synonymous with liquidity provision: a market-making strategy can flip to consuming liquidity when it needs to manage its own inventory.

The mechanical heart of the chapter is the limit order book. An exchange reduces to two primitive order types: market orders (MOs), which demand immediate execution at the best available price, and limit orders (LOs), which post a price and wait. Under ordinary price--time priority, an incoming MO is matched first against the best-priced resting LOs, and among orders at the same price, against whichever arrived first; if the MO is larger than what's resting at the best price it "walks the book," consuming progressively worse price levels until it is filled. The authors illustrate this with a genuinely useful picture: a sell MO for 250 shares meeting 200 shares resting at the best bid and 50 more needed from the next price level down, except that in the US, order-protection ("trade-through") rules mean the remaining 50 shares are as likely to be silently rerouted to another exchange quoting the same best price as they are to walk the book locally, which is part of why large orders in fragmented US equity markets tend to be sliced and scattered across venues within milliseconds rather than executed as one visible sweep.

A few numbers anchor the abstractions. The minimum tick size for US stocks above a dollar is one cent; European venues vary the tick with price, from a tenth of a cent up to five cents depending on the exchange. The quoted spread is simply the best ask minus the best bid, and the midprice, the average of the two, is used throughout the book as a proxy for the "true" price net of the trading friction represented by the spread. The chapter's NASDAQ snapshots of HPQ and FARO on the same day are a nice illustration of why liquidity matters as a distinct dimension from price: HPQ's book is densely populated at every tick for twenty ticks in either direction, while FARO's is thin and gapped, meaning the same-sized order would move FARO's price far more than HPQ's.

The chapter closes on two institutional details that matter more than they sound: colocation, where exchanges rent rack space next to their own matching engines so that paying clients get identical, minimal latency (which raises an obvious regulatory question about how "competitive" access to that advantage really is), and the maker--taker fee structure, in which liquidity takers (MO senders) typically pay a fee and liquidity providers (resting LO owners who get filled) receive a rebate, though some venues invert this on purpose. Because the price you actually realize is net of these fees, and different traders at different exchanges face different fee schedules, the "same" quoted price is not really the same net price for everyone, which the authors flag as a persistent, underappreciated source of distortion in a fragmented market.

== Week 5, A Primer on the Microstructure of Financial Markets (Ch. 2)

Where Chapter 1 was descriptive, Chapter 2 is the first place the book gets genuinely mathematical, and it does so by building up two toy models that answer the same underlying question from opposite directions: why does a market maker charge a spread at all, and what happens to that spread once some of the people she trades against know more than she does?

The chapter starts with the Grossman--Miller (1988) market-making model, which is really a model about the price of immediacy. Liquidity traders arrive wanting to transact now; market makers are willing to take the other side, but only if compensated for the risk of holding inventory until an offsetting order shows up. The compensation shows up as a price concession, and the model's punchline is intuitive once stated: the size of that concession scales with how much inventory risk the market maker has to absorb and for how long, which is why deep, frequently-traded markets have tight spreads and thin, infrequently-traded ones don't.

From there the authors build a static, deliberately simplified model of market making with limit orders that isolates the trade-off a market maker actually faces every time she decides where to post: post very close to the midprice and you get filled often but earn little per fill; post farther away and you earn more per fill but risk never being filled at all. Formalizing the probability that a limit order posted at depth $delta$ from the midprice gets filled as an exponentially decaying function of that depth, with decay parameter $kappa$, the model shows that the profit-maximizing depth is simply

$ delta^(plus.minus,*) = 1 / kappa^(plus.minus), $

which is to say, the optimal quoting distance is just the mean depth already implied by the market's own order-arrival dynamics. It's a clean result precisely because the model strips out everything else, no inventory cost, no informational asymmetry, infinite patience, and the authors are upfront that this is a stepping stone rather than a finished answer; a fuller, dynamic version of the same problem, with genuine inventory risk, reappears in Chapter 10.

The second half of the chapter turns to Kyle's (1985) model of informed trading, and it is where the chapter earns its keep. The setup: an asset has an uncertain terminal value $v$, an insider knows $v$ exactly, an anonymous mass of price-insensitive liquidity traders submits a random net order flow $u$, and competitive, risk-neutral market makers see only the combined order flow $x(v) + u$ and must set a price. Because the market makers can't tell the insider's order from the liquidity traders' noise, they can't extract it perfectly, but because they compete with each other for order flow, their expected profits are driven to zero regardless, which pins the pricing rule to a specific form: the price must equal the conditional expectation of $v$ given everything the market maker has observed, a condition the authors call semi-strong efficiency. Solving the resulting fixed point (the insider's optimal trade size given the pricing rule, and the pricing rule given the insider's optimal trade size) is the technical core of the section, but the intuitive payoff is simple and, I think, the single most important idea in the chapter: liquidity traders exist to provide camouflage. Without them, any order at all would reveal the insider's information and the market maker would price it away instantly; their presence is precisely what lets the insider extract a positive expected profit, at the liquidity traders' collective expense, by trading gradually rather than dumping his whole position at once. This is also the first appearance of price impact as an equilibrium object rather than a transaction-cost nuisance, the price literally moves with net order flow because that is how the market maker's zero-profit condition has to be satisfied.

The chapter's last section briefly runs the same logic from the market maker's side: if she knows she is trading against a mix of informed and uninformed flow but cannot distinguish them order by order, her optimal quoting response is to widen her spread just enough that the losses she expects to take against informed counterparties are covered by the premium she collects from uninformed ones. It's a short section, but it's the conceptual bridge to Chapter 10's adverse-selection-aware market making, where this trade-off is finally solved as a genuine dynamic control problem instead of a one-shot static game.

== Week 6, Stochastic Optimal Control and Stopping (Ch. 5)

Chapter 5 is the mathematical toolbox chapter, and it earns its place by being unusually honest about what it is and isn't trying to do: the authors say plainly that they are not interested in the subtleties that occupy a full stochastic-control textbook, only in the mechanics needed to actually solve the trading problems that show up later in the book. The two load-bearing tools introduced here are the dynamic programming principle (DPP) and its infinitesimal cousin, the Hamilton--Jacobi--Bellman (HJB) equation, sometimes called the dynamic programming equation. The DPP lets you solve a control problem backwards from the terminal date, and the HJB equation is what you get when you shrink that backward step to an instant, a nonlinear PDE that the optimal value function has to satisfy.

Rather than developing the theory in the abstract, the chapter works through three examples that set up nearly everything that follows in the book. The first is Merton's (1971) classical portfolio problem: an agent splits her wealth between a risky asset and a risk-free account to maximize expected utility of terminal wealth, choosing how many dollars $K_t$ to hold in the risky asset at each instant. What makes this example useful pedagogically rather than just historically is what it deliberately leaves out, the agent's trading has no effect on the asset's price. That assumption is completely reasonable for a long-horizon portfolio decision and completely wrong for someone trying to unload a large position in a single day, which is exactly the gap the next example is built to close.

The second example is the optimal liquidation problem, and it is the one that recurs most throughout the rest of the book. An agent holds a large inventory $frak(q)$ of shares she has decided are no longer worth holding, and wants to sell them by some horizon $T$. Because the market cannot absorb a large sell order at the best price without moving against her, dumping everything at once is a bad strategy; she needs to choose a selling rate $v_t$ over time, trading off the market-impact cost of selling quickly against the price risk of holding the position longer while she waits for a better trajectory. The model separates two distinct notions of impact that are easy to conflate: a permanent impact $g(v_t)$ that persistently shifts the fundamental price itself, and a temporary impact $h(v_t)$ that only worsens the execution price of the trade causing it, with no lasting effect on the market once the trade is done. The agent's value function,

$ H(x,S,q) = sup_(v in cal(A)_(0,T)) EE[X_T^v + Q_T (S_T^v - alpha Q_T) - phi.alt integral_0^T (Q_u^v)^2 dif u], $

bakes in a running penalty $phi.alt$ on holding nonzero inventory, a mathematical stand-in for the trader's own risk aversion or urgency, since without it the model would be happy to let her hold the position indefinitely waiting for the perfect moment to sell. This is the exact scaffolding, permanent versus temporary impact, a running inventory penalty, a terminal liquidation cost, that Chapter 10's market-making problems reuse almost unchanged, just with the sign and interpretation of the inventory flipped from "must sell it all" to "must keep it near zero while continuously quoting."

The third example, optimal limit order placement, previews the LOB-specific version of the same idea: instead of a continuous selling rate, the agent chooses where to post a resting order, and the control variable becomes a depth from the midprice rather than a trading speed, which requires extending the machinery from ordinary diffusion-driven control (Brownian motion in, HJB equation out) to control problems built around counting processes, the discrete arrivals of market orders that fill or miss a resting limit order. The chapter develops both flavours of the DPP and HJB equation, one for continuous diffusions and one for counting processes, because essentially every model in the rest of the book is built from one or a combination of the two: inventory evolves continuously or by jumps depending on whether the strategy trades via market orders or limit orders, and the choice of tool follows directly from that.

== Week 7, Market Making (Ch. 10)

Chapter 10 is where the two earlier threads, the static Grossman-Miller-style quoting problem from Chapter 2, and the stochastic control machinery from Chapter 5, finally get stitched together into a real, dynamic market-making model, and it's genuinely satisfying to see the payoff.

The baseline problem sets a market maker continuously quoting bid and ask depths $delta_t^-$ and $delta_t^+$ away from a midprice that itself diffuses randomly, with her limit orders filled by a doubly-stochastic counting process whenever an incoming market order is large enough to walk the book down to her quote. Her objective is to maximize terminal cash, subject to a running penalty $phi.alt$ on holding nonzero inventory and a liquidation cost $alpha$ for whatever position she's still carrying at the terminal date $T$:

$ H(t,x,S,q) = EE_(t,x,q,S)[X_T + Q_T (S_T - alpha Q_T) - phi.alt integral_t^T (Q_u)^2 dif u]. $

Solving the associated dynamic programming equation with the ansatz $H = x + q S + h(t,q)$, separating out cash already banked, the mark-to-market value of current inventory, and the expected value still to be earned from optimal quoting, is mechanically involved but conceptually clean, and the authors walk through the special case that makes the intuition obvious: if you strip out the running penalty and the terminal liquidation cost entirely ($phi.alt = alpha = 0$) and let inventory be unbounded, the optimal depths collapse to exactly the static Grossman-Miller-with-limit-orders result from Chapter 2,

$ delta^(+,*)(t,q) = 1 / kappa^+, quad delta^(-,*)(t,q) = 1 / kappa^-, $

i.e. quote to maximize fill probability and ignore inventory altogether, because there's genuinely nothing in the objective punishing you for carrying it. The moment you reintroduce $phi.alt$, the optimal quotes start depending on current inventory $q$ in exactly the way you'd hope: as her long position grows, her posted ask tightens (she wants to sell) and her posted bid widens (she's less eager to buy more); the numerical example in the chapter, run with a running-penalty sweep over $phi.alt in {10^(-5), 5 times 10^(-5), 10^(-3), 10^(-2)}$, shows the strategy's lifetime inventory histogram collapsing tightly around zero as $phi.alt$ grows, exactly the behaviour you'd want from a risk control.

A second version of the model restricts the market maker to quoting only at-the-touch, the best bid and best offer, with a fixed market spread $Delta$, which is a better description of very liquid markets where incoming orders rarely walk the book. Here the control becomes a binary decision, post or don't post on each side, and the resulting optimal strategy has an intuitive "withdrawal" structure: with the authors' example parameters ($phi.alt = 10^(-3)$, inventory bounds of $plus.minus 20$), the agent stops posting sell orders once her inventory falls to $-7$ or below and stops posting buy orders once it climbs to $+7$ or above, with the withdrawal thresholds moving closer to zero as $phi.alt$ increases, at $phi.alt = 0.1$ the agent essentially refuses to run any inventory at all, taking on at most one unit before immediately unwinding it. A companion section extends this to optimizing posted *volume* rather than just the binary post/don't-post decision, which produces a subtler and somewhat counterintuitive finding: the agent's optimal posted size at any given inventory level is often not large enough to bring her back to zero even if filled completely, meaning the model prescribes a gradual, multi-step unwind rather than an aggressive single correction, a result that would be easy to miss without actually solving the model, since the "obvious" answer would be to post exactly enough to flatten in one fill.

The chapter also shows that switching the market maker's objective from expected-cash-maximization-with-a-running-penalty to genuine exponential utility maximization of terminal wealth produces, after a change of variables, essentially the same optimal quoting strategy, the running inventory penalty $phi.alt$ in the first formulation and the risk-aversion parameter $gamma$ in the second turn out to be doing the same job, which is a nice bit of reassurance that the earlier, more tractable formulation wasn't hiding some important behaviour that only "true" risk aversion would capture.

The final section, on adverse selection, closes the loop back to Kyle's model from Chapter 2. Two channels are modelled: market orders that are themselves informative about the direction the midprice is about to move (so a market maker who gets lifted or hit is more likely to have traded just before an adverse price move), and short-term "alpha" signals the market maker herself might observe and want to skew her quotes around rather than quote symmetrically. In both cases the resolution is the same one Chapter 2 anticipated informally: a market maker who cannot avoid adverse selection compensates for it by asymmetric, wider quoting on the side she expects to be run over, financing her losses to informed flow out of the premium she earns from uninformed flow, except now, unlike in Kyle's static one-shot setting, the compensation is expressed as an explicit, time- and inventory-dependent optimal control rather than an equilibrium spread pulled out of a fixed-point argument.

#v(1em)
#line(length: 100%, stroke: accentgray)
#text(
  size: 9pt,
  fill: accentgray,
)[Source: Cartea, Álvaro, Sebastián Jaimungal \& José Penalva. _Algorithmic and High-Frequency Trading_. Cambridge University Press, 2015.]
