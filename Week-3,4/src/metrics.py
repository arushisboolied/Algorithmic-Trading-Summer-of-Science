import numpy as np
import pandas as pd
import config

class PerformanceMetrics:
    TRADING_DAYS = 252


    @staticmethod
    def total_return(equity_curve: pd.Series) -> float:

        return (equity_curve.iloc[-1] / equity_curve.iloc[0] - 1) * 100
    

    @staticmethod
    def annualised_return(equity_curve: pd.Series) -> float:

        n_years = len(equity_curve) / PerformanceMetrics.TRADING_DAYS
        if n_years == 0:
            return 0.0
        return ((equity_curve.iloc[-1] / equity_curve.iloc[0]) ** (1 / n_years) - 1) * 100
    

    @staticmethod
    def sharpe_ratio(equity_curve: pd.Series, rf: float = config.RISK_FREE_RATE) -> float:

        daily_returns = equity_curve.pct_change().dropna()
        daily_rf = rf / PerformanceMetrics.TRADING_DAYS
        excess = daily_returns - daily_rf
        if excess.std() == 0:
            return 0.0
        return float((excess.mean() / excess.std()) * np.sqrt(PerformanceMetrics.TRADING_DAYS))
    

    @staticmethod
    def max_drawdown(equity_curve: pd.Series) -> float:

        rolling_max = equity_curve.cummax()
        drawdown    = (equity_curve - rolling_max) / rolling_max
        return float(drawdown.min() * 100)
    

    @staticmethod
    def win_rate(trade_history: list[dict]) -> float:

        buys  = [t for t in trade_history if t["action"] == "BUY"]
        sells = [t for t in trade_history if t["action"] == "SELL"]

        pairs = min(len(buys), len(sells))
        if pairs == 0:
            return 0.0

        wins = sum(
            1 for b, s in zip(buys[:pairs], sells[:pairs])
            if s["price"] > b["price"]
        )
        return (wins / pairs) * 100
    
 
    @staticmethod
    def profit_factor(trade_history: list[dict]) -> float:

        buys  = [t for t in trade_history if t["action"] == "BUY"]
        sells = [t for t in trade_history if t["action"] == "SELL"]
        pairs = min(len(buys), len(sells))

        gross_profit = gross_loss = 0.0
        for b, s in zip(buys[:pairs], sells[:pairs]):
            pnl = (s["price"] - b["price"]) * b["shares"]
            if pnl > 0:
                gross_profit += pnl
            else:
                gross_loss += abs(pnl)

        return gross_profit / gross_loss if gross_loss > 0 else float("inf")
    

    @classmethod
    def summary_report(cls, equity_curve: pd.Series, trade_history: list[dict]) -> dict:

        return {
            "Total Return (%)" : round(cls.total_return(equity_curve),     2),
            "Annualised Return (%)" : round(cls.annualised_return(equity_curve), 2),
            "Sharpe Ratio" : round(cls.sharpe_ratio(equity_curve),      3),
            "Max Drawdown (%)" : round(cls.max_drawdown(equity_curve),      2),
            "Win Rate (%)" : round(cls.win_rate(trade_history),         1),
            "Profit Factor" : round(cls.profit_factor(trade_history),    2),
            "Total Trades" : len([t for t in trade_history if t["action"] == "BUY"]),
        }
    

    @classmethod
    def print_report(cls, equity_curve: pd.Series, trade_history: list[dict]) -> None:

        report = cls.summary_report(equity_curve, trade_history)
        width  = 30
        print("\n" + "═" * width)
        print("  BACKTEST RESULTS")
        print("═" * width)
        for key, val in report.items():
            print(f"  {key:<24} {val}")
        print("═" * width + "\n")