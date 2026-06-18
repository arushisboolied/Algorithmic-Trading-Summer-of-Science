import pandas as pd

class SMA:

    def __init__(self, short_window: int = 10, long_window: int = 100):
        self.short_window = short_window
        self.long_window = long_window


    def compute_sma(self, df: pd.DataFrame) -> pd.DataFrame:
        df = df.copy()
        df[f"SMA_{self.short_window}"] = df['Close'].rolling(window=self.short_window).mean()
        df[f"SMA_{self.long_window}"] = df['Close'].rolling(window=self.long_window).mean()

        return df
    

    def generate_signal(self, df: pd.DataFrame) -> pd.DataFrame:
        df = self.compute_sma(df)
        short_col = f"SMA_{self.short_window}"
        long_col = f"SMA_{self.long_window}"

        raw = pd.Series(0,index=df.index)
        raw[df[short_col] > df[long_col]] = 1
        raw[df[short_col] < df[long_col]] = -1

        df["Signal"] = raw.diff().clip(-1, 1)

        return df
    
    def get_trade(self, df: pd.DataFrame) -> list[dict]:
        df = self.generate_signals(df)
        trades = []
        
        for date, row in df[df["Signal"] != 0].iterrows():
            action = "BUY" if row["Signal"] == 1 else "SELL"
            trades.append({"date": date, "action": action, "price": row["Close"]})

        return trades
