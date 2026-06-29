
#import "@preview/tapestry:0.0.4": *

#show: tapestry.with(
  title: "Microstructure and Emperical Facts",
  year: "2026",
)

= Chapter 1
== Types of securities
=== Common stock
An *ordinary share* or *common stock* is a claim of ownership on the corporation that issues it. These claims are used by the company issuing the stock to raise money for their various ventures. A company that wishes to issue shares in this manner must get listed by an exchange, for which they must satisfy a list of conditions set by the regulartory bodies. This listing is tied to the first issuance of the shares(initial public offering, or *IPO*). A participant that buys this security gets a right to vote in the corporation's shareholders' meetings. A participant may benefit from the company's profits in the following two ways:
/ Capital Gains: This is when a shareholder sells their ownership to an interested buyer at a higher price than what they bought it for themselves.
/ Dividends: The company's board might decide to distribute a part of their profits. In this case the owner of the security gets an amount proportional to the number of shares they own.

=== Bonds
A *bond* is simply a contract by which the corporation (or in some cases the government - see government bonds) commits to paying the bond holder a regular income(interest) but in turn gives them no decision rights. This interest rate is of course usually higher than the rate one gets by depositing their money in a bank for example, and this is the incentive of the people buying these contracts. It is to be noted that a bond is fundamentally a safer security than an ordinary stock because it is a form of *debt* rather than *equity* (which a share is). If the company is in financial distress and has to liquidate its assets, the debt holder's claim to the assets holds priority over the equity holder's claims.

=== Preferred stock
A *preferred stock* is a hybrid between a bond and a common stock in the sense that the owner of this security gets a pre-arranged income an no voting rights but this security has the legal treatment of equity rather than debt.

=== Mutual funds
A *mutual fund* is a product that acts as an delegated investment manager. The owner of this security gives their cash to a financial management company that then use it build a portfolio of assets according to the firm's investment objectives. The management fees of the firm is included in these objectives. The owner of the security participates in both the appreciation and depreciation of the funds allocated by their fund manager. If the owner of this security wants to liquidate it, their course of action depends on the kind of mutual fund they opted for.
/ Closed ended fund: The shares of a *closed ended fund* cannot be sold back to the fund. The number of shares of a closed ended fund are fixed and are usually issued only once at their IPO. The owner of the security may sell these shares to an interested buyer instead.
/ Open ended fund: These funds issue a variable amount of shares. Shares can be created to meet the demands of new investors, or bought back by the fund as investors seek to redeem theirs. The _Net Average Value_ or _NAV_ of the fund is determined after the market's closing everyday.

=== Exchange Traded Funds (ETFs)
An *ETF* is a fund whose investment strategy is designed to closely mirror an asset that is usually not tradable through electronic means. An example of an ETF would be the Nifty50 ETF. The assets that the fund manager buys mirror those in proportion to the shares the Nifty50 index tracks. This is useful if an individual wants a diversified portfolio and reduce their trading costs.

=== Hedge Funds
*Hedge funds* are managed by established investors who pursue an aggresive trading strategy with their funds. These funds are not traded on exchanges.

== Market Participants
=== Fundamental Traders
These traders are driven by factors outside the exchange market. They trade because of trust in management of the company, interest in the company's ventures, portfolio rebalancing needs etc. From the point of view of a high frequency trading algorithm, their trades look like noise even if the traders themselves are quite informed about the underlying business.

=== Informed Traders
These traders earn profit by using specialized, private information not known to the ordinary trader, and trade in anticipation of an asset's appreciation or depreciation. Arbitrageurs, who exploit fleeting price differences between equivalent assets, are also typically placed in this category.

=== Market Makers
These are professional traders who profit from facilitating exchange in a particular asset and exploit their skills in executing trades. Their activity is generally passive -- they post both buy and sell limit orders and profit from the spread -- rather than initiating trades based on external information. It is worth noting that equating market making with liquidity provision and informed trading with liquidity taking is an oversimplification. A market maker may at times take liquidity and an informed trader may use passive orders to hide their intent.

== Trading in Electronic Markets
=== Orders and the Exchange
An electronic exchange needs a way for participants to signal their willingness to trade and a mechanism to match buyers with sellers. In the basic setup there are two order types. A *Market Order* (*MO*) is an aggressive order that seeks to execute immediately at the best available price. A *Limit Order* (*LO*) is a passive order where the participant specifies the price they are willing to trade at. Because this price is usually worse than the current market price, the LO will not execute immediately and instead waits in the *Limit Order Book* (*LOB*) until it is either matched with an incoming order or cancelled by the participant who placed it.

The LOB and a *matching engine* together manage all orders. Most exchanges use *price-time priority* -- an incoming buy MO is matched against the cheapest standing sell LOs, and among LOs at the same price the oldest one is executed first. If an MO is large enough to consume all the depth at the best price and still has quantity remaining, it moves on to the next price level and so on. This is called _walking the book_.

=== Alternate Exchange Structures
Price-time priority is not the only matching rule. Some money markets use _pro-rata_ matching, where an incoming MO is split proportionally among all LOs at the best price rather than by time of arrival. Some futures markets mix the two. Exchanges also often run auctions at the open and close of the trading day, and after a halt triggered by a volatility limit, to smooth the return to continuous trading.

Another important dimension is the transparency of the order book. *Lit* exchanges like NASDAQ and NYSE are required to publish their LOB state. *Dark* markets -- dark pools, ECNs, and broker-dealer internalisers -- do not. Even among lit exchanges there are differences: NASDAQ uses an order-based reporting system where each LO is assigned an ID that can be matched to later cancellations or executions, while NYSE uses a level-book method that records aggregate depth changes without tracking individual orders.

=== Colocation
Exchanges monetise the demand for speed by renting server space next to their matching engines. *Colocation* guarantees all colocated participants the same minimal latency to the exchange. This naturally creates a two-tier market -- colocated traders and everyone else, who will always face a speed disadvantage. In the US there are up to 13 lit and more than 40 dark venues, and this fragmentation combined with _trade-through rules_ (which govern what happens to an MO if better prices exist at other exchanges) adds considerable complexity to algorithm design.

=== Extended Order Types
Beyond MOs and LOs, exchanges offer many additional order types. Some examples include:
/ Day Orders: valid only for the current trading session, with options to extend to pre- or post-market.
/ Immediate-or-Cancel (IOC): executes as much as possible at the best price and cancels the rest, without walking the book or being re-routed.
/ Fill-or-Kill (FOK): executes in full at the best price or not at all.
/ Iceberg Orders: display only part of their quantity, with the hidden portion replenished automatically as the visible part is filled.
/ Good-Till-Time: carries a built-in expiry time after which it is cancelled if unfilled.

A trader designing an algorithm needs to be well acquainted with all the order types available at every venue they trade in. Some of these types interact with the matching engine at a level that no algorithm can match for speed.

=== Exchange Fees
Trading in an exchange is not free. Many exchanges use a *maker-taker* fee structure where the participant sending an MO (the liquidity taker) pays a fee while the participant whose LO gets filled (the liquidity maker) pays a lower fee or even receives a rebate. Some exchanges invert this, charging the maker and rebating the taker. Since fees alter the effective net price of a transaction, they distort observed market prices and their interaction in a fragmented multi-venue market is a matter of active debate.

== The Limit Order Book
The LOB is defined on a discrete price grid. The size of each step in this grid is called the *tick size* -- in the US this is a minimum of 1 cent for any stock priced above a dollar.

When a new LO arrives it joins the queue at its stated price, sitting behind all previously posted orders at that level. When an MO arrives the matching engine works through the LOB from the best price inward until the order is fully filled. Two quantities describe the state of the LOB at any moment:
/ Quoted Spread: $P^a_t - P^b_t$, the difference between the best ask $P^a_t$ and best bid $P^b_t$. The minimum possible spread is one tick.
/ Midprice: $frac(1, 2)(P^b_t + P^a_t)$, the arithmetic average of the best bid and ask. This is used as a proxy for the true underlying price of the asset, i.e. what the price would be if there were no trading costs and hence no spread.

A more refined proxy is the *microprice*, which weights the bid and ask by the volumes posted at those levels:
$ "Microprice"_t = frac(V^b_t, V^b_t + V^a_t) P^a_t + frac(V^a_t, V^b_t + V^a_t) P^b_t $
where $V^b_t$ and $V^a_t$ are the volumes at the best bid and ask respectively. If there is a lot of buying pressure the microprice is pushed towards the ask, signalling that prices are likely to increase, and vice versa for selling pressure.

The difference in liquidity across assets is stark when you look at actual LOB snapshots. A liquid asset like HPQ has LOs posted at every tick out to at least 20 ticks from the midprice, a spread of one tick, and over 1000 shares available at the best two price levels. An illiquid asset like FARO has thin and irregularly spaced bids and offers, a spread of 20 ticks on a roughly \$41 stock, and fewer than 100 shares at the best two levels combined. HPQ hit its 10,000th order book event of the day about 15 minutes after the market opened; FARO did not reach the same milestone until over two and a half hours after open.

In the US, order protection rules generally prevent a large MO from walking the book at a single venue -- instead it gets chopped up and routed across venues sequentially. When depth disappears across all venues simultaneously, as happened during the Flash Crash of May 6 2010, orders can end up matched against _stub quotes_ at completely absurd prices.


