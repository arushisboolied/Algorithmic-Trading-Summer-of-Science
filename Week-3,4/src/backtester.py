import os
import pandas as pd
from plotly.subplots import make_subplots
import plotly.graph_objects as go
import config
from src.data import Data
from src.strategy import SMA
from src.portfolio import Portfolio
from src.metrics import PerformanceMetrics


class Backtester:

    def __init__(self, strategy: SMA, portfolio: Portfolio, data: Data | None = None):
        self.strategy = strategy
        self.portfolio = portfolio
        self.data = data or Data()
        self.results_df: pd.DataFrame | None = None
        self._ticker = ""


    def run(self, ticker: str = config.TICKER, start: str = config.START_DATE, end:   str = config.END_DATE) -> dict:

        self._ticker = ticker

        # Load data
        print(f"[Backtester] Fetching {ticker} from {start} to {end} …")
        df = self.data.fetch_yfinance(ticker, start, end)

        # Generate signals
        df = self.strategy.generate_signal(df)

        # Simulate portfolio
        df = self.portfolio.apply_signals(df)
        self.results_df = df

        # Compute & print metrics
        PerformanceMetrics.print_report(
            self.portfolio.equity_curve,
            self.portfolio.trade_history,
        )

        return PerformanceMetrics.summary_report(
            self.portfolio.equity_curve,
            self.portfolio.trade_history,
        )

    def plot(self, save: bool = False) -> None:

        if self.results_df is None:
            raise RuntimeError("Call run() before plot().")

        df = self.results_df
        short_col = f"SMA_{self.strategy.short_window}"
        long_col = f"SMA_{self.strategy.long_window}"
        buys = df[df["Signal"] == 1]
        sells = df[df["Signal"] == -1]

        fig = make_subplots(
            rows=2, cols=1,
            shared_xaxes=True,
            row_heights=[0.65, 0.35],
            vertical_spacing=0.06,
        )

        # Top panel: price & SMAs 
        fig.add_trace(go.Scatter(
            x=df.index, y=df["Close"],
            name="Close", line=dict(color="#888888", width=1),
        ), row=1, col=1)

        fig.add_trace(go.Scatter(
            x=df.index, y=df[short_col],
            name=f"SMA {self.strategy.short_window}",
            line=dict(color="#1f77b4", width=1.5),
        ), row=1, col=1)

        fig.add_trace(go.Scatter(
            x=df.index, y=df[long_col],
            name=f"SMA {self.strategy.long_window}",
            line=dict(color="#ff7f0e", width=1.5),
        ), row=1, col=1)

        fig.add_trace(go.Scatter(
            x=buys.index, y=buys["Close"],
            name="BUY", mode="markers",
            marker=dict(symbol="triangle-up", color="green", size=10),
        ), row=1, col=1)

        fig.add_trace(go.Scatter(
            x=sells.index, y=sells["Close"],
            name="SELL", mode="markers",
            marker=dict(symbol="triangle-down", color="red", size=10),
        ), row=1, col=1)

        # Bottom panel: equity curve 
        fig.add_trace(go.Scatter(
            x=df.index, y=df["Total"],
            name="Portfolio value",
            line=dict(color="steelblue", width=1.5),
            fill="tozeroy", fillcolor="rgba(70,130,180,0.08)",
        ), row=2, col=1)

        fig.add_hline(
            y=self.portfolio.initial_capital,
            line=dict(color="grey", dash="dash", width=1),
            annotation_text="Initial capital",
            annotation_position="top left",
            row=2, col=1,
        )

        # Layout 
        fig.update_layout(
            title=f"{self._ticker} — SMA({self.strategy.short_window}, "
                  f"{self.strategy.long_window}) Backtest",
            hovermode="x unified",
            legend=dict(orientation="h", yanchor="bottom", y=1.02,
                        xanchor="right", x=1),
            template="plotly_white",
            height=700,
        )
        fig.update_yaxes(title_text="Price ($)",  row=1, col=1)
        fig.update_yaxes(title_text="Equity ($)", row=2, col=1)
        fig.update_xaxes(title_text="Date",       row=2, col=1)

        if save:
            os.makedirs(config.PLOTS_DIR, exist_ok=True)
            path = os.path.join(config.PLOTS_DIR, f"{self._ticker}_sma_backtest.html")
            fig.write_html(path)
            print(f"[Backtester] Chart saved → {path}")
        else:
            fig.show()