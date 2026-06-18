import yfinance as yf
import pandas as pd

class Data:
    
    COLUMNS = {"Open","Close","High","Low","Volume"}

    def fetch_yfinance(self, ticker: str, start: str, end: str)->pd.DataFrame:

        df = yf.download(ticker, start = start, end = end, auto_adjust=True, progress=False)
        df.columns = df.columns.get_level_values(0)

        df.index.name = "Date"
        df = self._clean(df)

        return df
    
    def _clean(self, df: pd.DataFrame):
        available = [c for c in self.REQUIRED_COLUMNS if c in df.columns]
        df = df[available].copy()
 
        df.ffill(inplace=True)
        df.dropna(inplace=True)

        return df
