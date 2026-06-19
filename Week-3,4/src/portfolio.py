import pandas as pd
import config

class Portfolio:

    def __init__(self, initial_capital: float = config.INITIAL_CAPITAL, commission: float = config.COMMISSION):
        self.initial_capital = initial_capital
        self.commission = commission

        self.positions : pd.Series | None = None
        self.cash : pd.Series | None = None
        self.equity_curve : pd.Series | None = None
        self.trade_history: list[dict] = []
    
    
    def apply_signals(self, df: pd.DataFrame) -> pd.DataFrame :
        
        df = df.copy()
        df['Trade'] = df['Signal'].shift(1).fillna(0)

        n = len(df)
        position = [0.0]*n
        cash = [self.initial_capital]*n

        for i in range (1,n):
            signal = df['Trade'].iloc[i]
            open_price = df["Open"].iloc[i]
            prev_pos   = position[i - 1]
            prev_cash  = cash[i - 1]

            if signal == 1 and prev_pos == 0:        #BUY
                shares = prev_cash // open_price
                cost   = shares * open_price
                fee    = cost * self.commission
                position[i] = shares
                cash[i]     = prev_cash - cost - fee
                self._log_trade(df.index[i], "BUY", open_price, shares, fee)

            elif signal == -1 and prev_pos > 0:     #SELL
                proceeds = prev_pos * open_price
                fee      = proceeds * self.commission
                position[i] = 0
                cash[i]     = prev_cash + proceeds - fee
                self._log_trade(df.index[i], "SELL", open_price, prev_pos, fee)

            else:                                    #HOLD
                position[i] = prev_pos
                cash[i]     = prev_cash
        
        df["Position"] = position
        df["Cash"]     = cash
        df["Holdings"] = df["Position"] * df["Close"]
        df["Total"]    = df["Cash"] + df["Holdings"]
        df["Returns"]  = df["Total"].pct_change().fillna(0)

        self.positions    = df["Position"]
        self.cash         = df["Cash"]
        self.equity_curve = df["Total"]

        return df
    

    def _log_trade(self, date, action: str, price: float, shares: float, fee: float) -> None:
        self.trade_history.append({
            "date":   date,
            "action": action,
            "price":  price,
            "shares": shares,
            "fee":    fee,
            "value":  shares * price,
        })
