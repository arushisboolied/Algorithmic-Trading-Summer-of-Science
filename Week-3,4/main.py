import config
from src.backtester import Backtester
from src.portfolio import Portfolio
from src.strategy import SMA


def main():
    strategy  = SMA(
        short_window = config.SHORT_WINDOW,
        long_window  = config.LONG_WINDOW,
    )

    portfolio = Portfolio(
        initial_capital = config.INITIAL_CAPITAL,
        commission      = config.COMMISSION,
    )

    bt = Backtester(strategy=strategy, portfolio=portfolio)

    bt.run(
        ticker = config.TICKER,
        start  = config.START_DATE,
        end    = config.END_DATE,
    )

    bt.plot(save=False) 


if __name__ == "__main__":
    main()