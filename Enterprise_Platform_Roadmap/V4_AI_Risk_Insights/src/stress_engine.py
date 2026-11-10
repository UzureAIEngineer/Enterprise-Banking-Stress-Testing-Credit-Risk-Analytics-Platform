from dataclasses import dataclass, asdict
SCENARIOS={"Baseline":{"pd":1.0,"lgd":1.0},"Mild_Stress":{"pd":1.25,"lgd":1.10},"Severe_Stress":{"pd":1.75,"lgd":1.25}}
BASE_PD={"Low Risk":.02,"Medium Risk":.05,"High Risk":.10}
BASE_LGD={"Mortgage":.20,"Auto Loan":.35,"SME Loan":.40,"Corporate Loan":.45,"Personal Loan":.60,"Credit Card":.85}
@dataclass(frozen=True)
class StressResult:
    scenario_name:str; risk_segment:str; product_type:str; ead:float; base_pd:float; stressed_pd:float; base_lgd:float; stressed_lgd:float; base_ecl:float; stressed_ecl:float; incremental_stress_loss:float
    def to_dict(self): return asdict(self)
def risk_segment(score):
    return "Low Risk" if score>=750 else "Medium Risk" if score>=650 else "High Risk"
def calculate_stress(score,balance,product,scenario):
    if scenario not in SCENARIOS: raise ValueError("Unknown scenario")
    if product not in BASE_LGD: raise ValueError("Unknown product")
    if not 300<=score<=900: raise ValueError("Credit score must be 300-900")
    if balance<=0: raise ValueError("Balance must be positive")
    seg=risk_segment(score); ead=float(balance); bpd=BASE_PD[seg]; blgd=BASE_LGD[product]
    spd=min(bpd*SCENARIOS[scenario]["pd"],1); slgd=min(blgd*SCENARIOS[scenario]["lgd"],1)
    becl=ead*bpd*blgd; secl=ead*spd*slgd
    return StressResult(scenario,seg,product,round(ead,2),bpd,round(spd,6),blgd,round(slgd,6),round(becl,2),round(secl,2),round(secl-becl,2))
