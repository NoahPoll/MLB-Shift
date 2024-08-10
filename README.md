# Recovering a Causal Effect from AA Baseball Restricting the Shift on Batter Outcomes

## Introduction

In baseball, what impact does restricting the shift have on batters? The MLB defines the shift as:

> “A term used to describe the situational defensive realignment of fielders away from their ‘traditional’ starting points.”

In practice, this means positioning three or more infielders on the same side of second base, commonly referred to as the “skewed alignment shift.” Some shifts involve moving a traditional infielder to the outfield, though these instances are rare. The objective of the shift is to place the defense in the most advantageous position to record an out, achieved by moving players to where the opponent is most likely to hit the ball.

Shifts have become a significant topic of discussion among baseball fans, managers, and analysts. The frequency of shifts has increased dramatically over the past 13 years. For instance, in 2011, shifts were employed in 1.65% of plate appearances, while by 2021, this had risen to 35.87%. Even within Major League Baseball (MLB), there is considerable variance in how often teams deploy the shift against opposing batters. 

For example:
- The 2021 Los Angeles Dodgers shifted 58.7% of the time.
- The Philadelphia Phillies in the same year shifted 20.7% of the time.
- The San Francisco Giants shifted 34.7% of the time, ranking 19th.

This discrepancy in shift frequency may be influenced by various confounders. In 2023, the MLB restricted the shift to increase offensive numbers league-wide, raising questions about the shift's effectiveness.

An MiLB.com article stated, “These restrictions on defensive positioning are intended to increase the batting average on balls in play.” An overarching theme of the MLB’s rule change initiatives is to make the game more exciting for fans, which is usually interpreted as higher scoring games, so if the rule change causes that trend as well, it is considered a success. At an economic level, this would increase fan engagement, leading to higher ticket sales, more lucrative television contracts, and increased revenues.

Our analysis estimates that restricting the shift causes a 0.006 percentage point increase in batting average on balls in play (BABIP). This analysis utilizes data generated from the restriction of the shift at the AA level in 2021.

## Existing Work

Connelly Doan published an article in the Baseball Research Journal aimed at studying players’ approaches to the shift. The main goal was to determine how batters and pitchers were reacting to the shift, whereas this research’s goal is to determine whether a causal relationship exists between the shift restrictions and batter outcomes. That article’s analysis is fundamentally different from this research’s analysis, as Doan uses descriptive statistics to look at trends in batted ball data, while this project includes a strategy for determining causal effect. 

Travis Sawchik wrote the book Big Data Baseball, which extensively describes the history of the shift, how it was implemented, anecdotal evidence of the shift ‘working’, and some statistical analysis to support his claims. For example, he tries to isolate the effectiveness of shifts by looking at year-to-year BABIP data at the major league level, noting that, “From 2006 to 2008, the major league batting average on balls in play hovered between .303 and .300, around the historical average. The number fell to .295 in 2011 and to .293 in 2013.” However, there are a few things that separate this proposal from Sawchik’s book – this research is meant to be succinct and it attempts to discover a causal effect which inform policy implications in today’s world. Sawchik also focuses on the story of the Pittsburgh Pirates, centralizing their playoff berth as the topic of the book and their data-driven adjustments as the reason for the playoff berth. This research focuses on baseball more broadly, approaching the shift from an interleague perspective, comparing AA to A to MLB. 

There has also been research done on the defensive side of the ball. For example, in “Quantifying the Effect of the Shift in Major League Baseball”, Christopher John Hawke Jr. uses a mathematical framework for understanding how good outfielders are. He uses a probit regression to establish a baseline skill level denoted by  for outfielders and determines the relative skill level of other players based on that  value. Hawke uses similar tools as this research, but it is applied to the skill level of outfielders, “quantify[ing] how positioning of defensive players… affects the success of those players”. Again, this research’s main goal is to determine if there is a causal effect of restricting the shift on batter statistics that indicate more action. Also, Hawke’s research, while intellectually stimulating, requires a higher baseline understanding of mathematical concepts than this research. The next piece of existing work on shifts in baseball is more directly related to what this research is focused on.

“Banning Shifts May Not Make Much Difference in MLB” is not a paper from a peer reviewed journal, but rather an article posted on Baseball America. Kyle Glaser uses minor league BABIP data to compare season by season statistics at the AA level, concluding that there was not a significant effect on BABIP as a result of the ban of the shift. However, the problem with this result is that Glaser uses 2019 AA and 2018 AA as control groups, without any reasoning why 2021 AA in the control state of the world should be comparable to those years. The players that played in 2021 AA may have been fundamentally different than those in 2019 and 2018 – and a plausible explanation for why would be the COVID-19 pandemic that prevented players from competing in 2020, possibly affecting the quality of batters in 2021 AA. If we assume this scenario is true, then the 2021 AA batters may have recorded a .280 BABIP with the shift still allowed (control state) and in reality they did benefit from the shift ban, as their BABIP with the shift ban in place was .307 overall. This is all theoretical, of course, so what this research attempts to do is recover a causal effect by using a difference in differences regression, essentially creating a comparable control group. 

## Data

Baseball Reference, a key data source for baseball analytic data,  has minor league and major league statistics for team level run output, batting averages, and home run totals for 2014-2022.  Using this data, we explore the causal relationship with the rule change and those outcome variables. I do not have any concerns about measurement problems (or non-response), as the data comes from the MLB, and both people who work for MLB organizations and outsiders rely on the accuracy of the statistics. First, I exported the team level MLB stats, including the “standard stats” such as games, at bats, plate appearances, etc., and then calculated BABIP from those. To calculate BABIP, we use the values of the observations in the columns for hits (h), home runs (hr), at bats (ab), strikeouts (k), and sacrifice flies (sf). Then, I did the same for AA, which was separated by league (Texas League, Eastern League, Southern League), sorted by alphabetical order by affiliation, then imported the combined excel file into Stata. Various data preprocessing steps were required for input into Stata including renaming certain variables (2B and 3B as doubles and triples respectively) as well as dropping columns that were not relevant to the analysis. I also renamed ‘finals’, a variable representing team name to ‘name’. On the player level, FanGraphs data for MLB is blocked by a subscription paywall. In addition, if we try to include multiple minor leagues, players that played in multiple leagues have their stats combined into one line, which complicates our analysis. What we have to do in this scenario is export data sets for each league individually and then merge them in Stata, which is a future application. There are 480 observations (teams) in the data set. Summary statistics can be found in table 3.
![Table 3](tables%20and%20graphs/sumstats%20pic.png)


## Identification Strategy

We employ a difference-in-differences approach for computing the causal effect. First, consider what a naive OLS would look like in this setting. Imagine a regression that attempts to use the status of the shift as the independent variable and BABIP (or another statistic) as the dependent variable. This would simply find the correlation between the two variables and be subject to omitted variable bias. There may be variables that are correlated with the shift being banned that also cause a change in batter outcomes. For example, perhaps umpires cracked down on illegal “spider tack” use at the same time that the shift was banned. In this scenario, there is a decrease in the use of spider tack that happens concurrently with the shift being banned, so if batter outcomes improve, we cannot determine what caused this change. Suppose the researcher tries to control for an omitted variable (or variables). It may be plausible to approximate the use of spider tack by observing spin rates of pitches (which may be noisy), but there are also concerns that there are unobservable variables that produce omitted variable bias that it would be difficult – or even impossible – to control for. 
Then, imagine there is an attempt to use the AA shift ban as a random experiment. After all, one may argue that it is a quasi-random choice by the MLB to choose AA to receive the ban. Then, a plausible control group for this experiment would be a different level of baseball to compare it to – say A+. However, the MLB also chose to implement a rule change at the A+ level: the pitcher has to step off the rubber to make a pickoff attempt. This by itself is a problem, but one might argue that the effect of this on batter outcomes such as BABIP is minimal – it would more likely impact stolen bases, which might impact RBIs for the following batters. Even if this claim holds and the rule change doesn’t affect batter outcomes, it is likely that players in A+ are fundamentally different from players in AA. For example, batters are likely less skilled in A+, as well as pitchers, so unless the talent gap is exactly the same in both leagues, the control group is not a good counterfactual to the treatment group. This problem is solvable using differences-in-differences because, as the name suggests, it adjusts for differences between treatment and control groups that are constant over time.

To setup the difference-in-differences, we need a dummy variable that equals 1 if a unit is ever treated – in this case, call it RESTRICT_l, which equals 1 if the league (l) is AA (where the defense is restricted) and 0 otherwise. This will control for differences between treatment and control units that don’t change over time. Then we need a dummy variable that equals 1 if the time period is after treatment – call it POST_t, which equals 1 if the year is 2021 or later and 0 otherwise. This will control for variables that change over time for all units regardless of treatment. We need an interaction term RESTRICT_l * POST_t, Where the coefficient estimate will be the treatment effect. This interaction will pick up differences for treatment units that are not explained by the baseline differences from control units or by the change over time for control units. This term will equal 1 for AA observations in years 2021 and later. We write our regression equation as: 

(1) Y_lt= alpha + beta * RESTRICT_l + gamma * POST_t + delta * rDD(RESTRICT_l * POST_t)+ e_lt 

where Y_lt is our outcome variable, which will be BABIP, runs per game, batting average, home runs per game, etc. run in separate regressions. An extension to this model is a fixed effects model: 

(2) Y_lt= alpha + delta * rDD(RESTRICTl*POSTt) + v_y + v_l + v_t + e_lt

where v_y represents year fixed effects to control for league-invariant temporal shocks such as COVID, v_l represents league fixed effects to control for time-invariant league characteristics such as average age of minor leaguers being younger, and v_t represents team fixed effects to control for time-invariant team characteristics such as the ballpark they play at.

In order for this strategy to recover a causal estimate, two key assumptions have to be satisfied: parallel trends and no spillovers. First, the parallel trends assumption states that in the absence of treatment, both groups would have common trends, meaning the direction and magnitude of the difference from one time period to the next is the same between the two groups. In this scenario, we need batter outcomes in MLB and AA to change the same amount in 2021, the year the shift was banned, had the shift stayed a valid part of the game. Note that we cannot observe this, but we can indirectly test this assumption by observing the difference in batter outcomes in years prior to 2021. If the batter outcomes differ by a similar amount in years prior to 2021, the parallel trends assumption is satisfied. The trends that indirectly test this assumption are plotted in figures 1 through 8. BABIP and sacrifices per game showed parallel trends, while the other statistics did not. 

Another assumption has to be satisfied – that there are no spillovers from the treatment into the control group. If the treatment affects the control group’s outcomes, then it is no longer a good counterfactual for the treatment group. In the context of baseball, one possible spillover is that players move from league to league. Take a player that starts in AA and then goes up to the MLB. They may have made adjustments to their swing in the preseason based on the shift ban, pulling more balls. Then, maybe some developmental coaches do not want to change a player’s swing midseason, so they keep this approach in the MLB, but it is not as successful because teams are allowed to shift. Then, they do not represent a good counterfactual to a AA player without the shift ban because they changed their swing due to the shift ban when they wouldn’t have otherwise. Players like this are rare at the minor league level because at that point the shift ban is undergoing a trial period where it is unclear if it will be a rule enforced at the highest level of baseball. Additionally, it is likely that players adjust their swings (or choose to bunt more frequently) depending on if there is a shift during that plate appearance, not for an entire season. 

Although unlikely, these players may exist, posing a threat to the identification used in this research. If it were to occur, a player (or players) might record high BABIPs of .350 in AA and then once in MLB, they record lower BABIPs of .294. In this scenario, when we calculate the difference in differences estimate, we would find a higher effect from the shift ban than what actually happened. It is also possible that parallel trends does not hold due to a variable that is changing over time and doing so differently in the two levels of baseball. One could imagine that the time off from baseball during 2020 could have changed training habits for different players. Imagine AA players who were not making much money to begin with, and then they cannot work for a whole year due to the pandemic. There were also talks of getting rid of some minor league teams, specifically cutting down the amount of player jobs available. This likely would weed out older players who don’t have much hope of making the MLB, but who could have performed well in AA had this policy not been put into place. This would bias batter outcomes in AA. If this doesn’t affect batter outcomes in the MLB in the same way, parallel trends is violated. There also are rule changes that occur each year that differ between the MLB and AA, which can cause a violation of parallel trends. For example, the runner on 2nd base in extra innings rule was implemented in AA in 2018, while it wasn’t implemented in MLB until 2020. We have these assumptions that seem reasonable; however, they might not be satisfied, which would lead to incorrect results.

## Results

Conventional wisdom in baseball suggests that since players shift into areas of the field that batters are more likely to hit into, the shift lowers BABIP. Therefore, banning the shift opens those areas back up for the batters, raising BABIP. In Table 1, the 2 by 2 difference in differences, all outcomes, including BABIP, saw significant impacts due to the shift restriction. 
![Table 1](tables%20and%20graphs/2x2%20DinD%20Model%20Table%20Landscape.png)


In Table 2, the fixed effects model, the effect shows up as a positive value of .006, meaning the shift increased team BABIP by .006 percentage points. 
![Table 2](tables%20and%20graphs/Fixed%20Effects%20Model%20Table%20Landscape.png)

Given that this is statistically significant at the 1% level, that is evidence that banning the shift does indeed increase BABIP. We performed various other experiments to see which other offensive outcomes may be impacted by the shift restriction. The estimated effect for on base percentage, slugging percentage, and on base plus slugging percentage is statistically insignificant. Scoring is up due to the shift restriction, as teams scored .136 runs per game more, only significant at the 10% level. Lastly, home runs were more common after the shift restriction, increasing by .087 per game, meaning fans saw an additional home run about 1 out of every 11 games. This is surprising, as the main focus was on increasing batting average on balls in play, and a home run isn’t counted as a ball in play. Although this result is surprising, there are possible explanations. Maybe pull hitters are affected by the shift restriction more, where previously, they might have been trying to hit the ball to the open field to react against the shift, hitting less home runs as a result, but now, they play to their strengths, pulling the ball and hitting with more power more frequently, resulting in more home runs. Meanwhile, batting average decreased by .004, only significant at the 10% level. Sacrifices per game decreased by .060, statistically significant at the 1% level, indicating that the shift restrictions caused batting approaches to change.

The effects on average, runs per game and home runs per game should be investigated further, as parallel trends is unlikely to hold. One interesting caveat is that the shift ban and other rules like it are meant to make the game more exciting, but walks leading to a higher on base percentage is a positive batter outcome that (arguably) might not make the game more exciting. (walks in and of themselves are anti-climactic, but they do increase the likelihood of a stolen base or runs, so they could indirectly make the game more exciting). Even a positive estimate does not provide strong evidence for the rule making baseball more exciting. That is why the main focus of the paper is BABIP and home runs– they are statistics that have the most implications for policy. 

## Future Applications

There are many possible extensions to this work including utilizing ground ball data to look at specific changes in batters' approaches. This can be accessed publicly at the major league level at Baseball Savant. We can use the statcast search feature to sort whether or not a pitch was hit as a ground ball or not. As far as making a comparison to the minor leagues, the best measurement of ground balls is the batted ball type on MiLB.com’s prospect search engine.
Another future possibility is using FanGraphs’ player level data. With player level data, the results might be more convincing by looking at individual changes in batting outcomes. Also, with specific data on players, we can more accurately explain the surprising increase in home runs. For a more comprehensive study, we could use other leagues as controls, such as A+, A, or AAA. Then we could investigate some of the batting outcomes where parallel trends didn’t hold for the MLB, such as runs per game and home runs per game. Lastly, if we analyze more post treatment observations, we’ll get a better understanding of how the shift restriction’s effects play out long term, whether or not there’s continuous improvement by batters as they continue to adjust, or whether or not there’s a strategic counter by pitching and defense looking for an alternative option to extreme shifts.


## Conclusion

There have been concerted efforts by the MLB to make the game more exciting to appeal to viewers as its fan base ages and growth is slowing. Other leagues like the NBA and NFL can rely on flashy stars with large social media followings to carry ratings. The MLB has to resort to less conventional strategies at times, considering rules changes like a shift restriction or ban, a pitch clock, and larger bases. Most baseball analytics related to the shift have focused on ideal positioning to impact winning at a team level. In this paper, we provide related insights on a broader, league wide view of the shift: restricting the shift has meaningful positive impacts on BABIP and home runs per game. The effects on other positive batting outcomes are not statistically significant, and parallel trends did not hold between 2014-19. It is unreasonable to assume that parallel trends would hold for 2019 to 2022.

	The question as to why home runs saw an increase is intriguing. The decrease in sacrifices might indicate that instead of bunting, hitters swung away, resulting in more home runs. There could have been different coaching philosophies due to the shift restriction, leading to less emphasis on using the whole field and more emphasis on maximizing power. Overall, the evidence suggests that the 2023 rule change to restrict the shift at the major league level was a positive change, and I would suggest taking it a step further, banning the alternative defensive positioning that teams use, termed ‘shading’, where the shortstop plays up the middle against left-handed pull hitters and the third baseman moves over to the shortstop’s traditional position.
 
	This evidence serves as an extension to existing literature by estimating a causal effect of a rule change restricting the shift, indicating that the shift restriction increased positive batting outcomes as intended. A possible problem is that not all batting outcomes followed parallel trends between AA and MLB, and that assumption is inherently untestable. Overall, this research suggests that rules changes like shift restrictions can have immediate impacts on batters and teams more generally. There is still room to expand on this analysis, as there are a myriad of rules changes that the MLB can consider to improve the game.

## Works Cited

1. **“2021 Register League Encyclopedia.”** *Baseball Reference*.  
   Available at: [Baseball Reference](https://www.baseball-reference.com/register/league.cgi?year=2021).

2. **Arthur, “Do MLB Teams Undervalue Defense—Or Just Value It Differently?”**  
   *FiveThirtyEight.com*, 18 Apr. 2017.  
   Available at: [FiveThirtyEight](https://fivethirtyeight.com/features/do-mlb-teams-undervalue-defense-or-just-value-it-differently).

3. **Blengino, “How Is MLB’s Shift Ban Playing Out? Just Look At Max Muncy And These Nine Other Pull Hitters.”**  
   *Forbes*, 18 Apr. 2023.  
   Available at: [Forbes](https://www.forbes.com/sites/tonyblengino/2023/04/18/micro-level-mlb-shift-ban-exammax-muncy-others-it-helps-most/?sh=7e80d4da3f04).

4. **Cockcroft, Tristan H. “A Primer on BABIP.”**  
   *ESPN*, 9 Feb. 2011.  
   Available at: [ESPN](https://www.espn.com/fantasy/baseball/flb/story?page=mlbdk2k11babipprimer).

5. **Doan, “Shifting Expectations: An In-Depth Overview of Players' Approaches to the Shift Based on Batted-Ball Events.”**  
   *Gale*, Fall 2019.  
   Available at: [Gale](https://go.gale.com/ps/i.do?id=GALE%7CA609260804&sid=googleScholar&v=2.1&it=r&linkaccess=abs&issn=07346891&p=AONE&sw=w&userGroupName=mlin_w_willcoll).

6. **Feinsand, Mark. “MLB, MLBPA Agree to New CBA; Season to Start April 7.”**  
   *MLB.com*, 11 Mar. 2022.  
   Available at: [MLB.com](https://www.mlb.com/news/mlb-mlbpa-agree-to-cba#:~:text=In%20exchange%20for%20agreeing%20to,pick%20compensation).

7. **Gartland, Dan. “Si:Am: MLB Goes after Minor Leagues (Again).”**  
   *Sports Illustrated*, 15 Feb. 2022.  
   Available at: [Sports Illustrated](https://www.si.com/mlb/2022/02/15/mlb-lockout-minor-league-reserve-list-limits#:~:text=First%2C%20some%20background%3A%20In%20December,for%20all%2030%20MLB%20clubs).

8. **Glaser, “Banning Shifts May Not Make Much Difference in MLB.”**  
   *Baseball America*, 9 Mar. 2022.  
   Available at: [Baseball America](https://www.baseballamerica.com/stories/banning-shifts-may-not-make-much-difference-in-mlb).

9. **Hawke, “Quantifying the Effect of the Shift in Major League Baseball.”**  
   *Bard College*, Spring 2017.  
   Available at: [Bard Digital Commons](https://digitalcommons.bard.edu/senproj_s2017/191).

10. **Melville et al., “Optimizing Baseball Fielder Positioning with Consideration for Adaptable Hitters.”**  
    Available at: [PDF](https://assets-global.website-files.com/5f1af76ed86d6771ad48324b/65bfe4996c2c54376b78d238_193963%20-%20Optimizing%20Baseball%20Fielder%20Positioning%20with%20Consideration%20for%20Adaptable%20Hitters.pdf).

11. **“MLB Team Fielder Positioning.”**  
    *Baseballsavant.com*.  
    Available at: [Baseball Savant](https://baseballsavant.mlb.com/visuals/team-positioning?teamId=111&venue=home&firstBase=0&shift=1&batSide=&season=2021).

12. **“MLB to Experiment with Bigger Bases at Triple-A During 2021 Season.”**  
    *MiLB.com*, 11 Mar. 2021.  
    Available at: [MiLB](https://www.milb.com/news/mlb-bigger-bases).

13. **Montes, “Optimizing Outfield Positioning: Creating an Area-Based Alignment Using Outfielder Ability and Hitter Tendencies.”**  
    *SABR Journal*, Spring 2021.  
    Available at: [SABR](https://sabr.org/journal/article/optimizing-outfield-positioning-creating-an-area-based-alignment-using-outfielder-ability-and-hitter-tendencies).

14. **Pastuovic, Michael. “The Shift.”**  
    *Northwestern Sports Analytics Group*, 13 Dec. 2020.  
    Available at: [Northwestern Sports Analytics](https://sites.northwestern.edu/nusportsanalytics/2020/12/13/the-shift/).

15. **Petriello, “No More Shift Could Mean Quite a Few More Hits for These Batters.”**  
    *MLB.com*, 4 Jan. 2023.  
    Available at: [MLB](https://www.mlb.com/news/hitters-likely-to-be-affected-by-shift-ban).

16. **“Prospect Search: Prospect Pipeline.”**  
    *MLB.com*.  
    Available at: [MLB Prospects](https://www.mlb.com/prospects/stats/search).

17. **Sawchik, Big Data Baseball: Math, Miracles, and the End of a 20 Year Losing Streak.**  
    *HarperCollins*, 19 May. 2015.

18. **“Shifts: Glossary.”**  
    *MLB.com*.  
    Available at: [MLB Glossary](https://www.mlb.com/glossary/statcast/shifts).

19. **Simon, Mark, and Harris Yudin. “Putting (Synthetic) Statcast Numbers on Top Minor League Sluggers.”**  
    *Sports Info Solutions*, 3 Mar. 2022.  
    Available at: [Sports Info Solutions](https://www.baseballinfosolutions.com/2022/03/03/putting-synthetic-statcast-numbers-on-top-minor-league-sluggers/).

20. **“Statcast Search.”**  
    *Baseballsavant.com*.  
    Available at: [Baseball Savant](https://baseballsavant.mlb.com/statcast_search).

21. **Verducci, Tom. “All the Changes Coming to Baseball in 2021.”**  
    *Sports Illustrated*, 1 Apr. 2021.  
    Available at: [Sports Illustrated](https://www.si.com/mlb/2021/04/01/mlb-rule-changes-2021-shift-pitch-clock-extra-innings).

22. **Verducci, “How Banning Infield Shifts Will Change MLB.”**  
    *Sports Illustrated*, 21 Nov. 2022.  
    Available at: [Sports Illustrated](https://www.si.com/mlb/2022/11/21/banning-infield-shifts-impact).

23. **Woolley, Andrew. “Sweeping Changes for Minor League Baseball Games Include Extra-Inning Runner at 2nd.”**  
    *USA Today*, 14 Mar. 2018.  
    Available at: [USA Today](https://www.usatoday.com/story/sports/mlb/2018/03/14/minor-league-baseball-rule-changes-runner-second-extra-innings-pitch-clock/424808002/).

---

Peer Review By Hikaru Hayakawa and David Goetze.


### Contact

For any questions or feedback, please open an issue on GitHub or reach out at [noahdpoll@gmail.com](mailto:your.email@example.com).

### Acknowledgments

I would like to thank Owen Thompson and those who provided valuable feedback and data for this project.

