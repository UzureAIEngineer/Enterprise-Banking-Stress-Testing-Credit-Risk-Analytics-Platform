import pandas as pd, streamlit as st
from dotenv import load_dotenv
from stress_engine import SCENARIOS, BASE_LGD, calculate_stress
from ai_explainer import explain
load_dotenv(); st.set_page_config(page_title="Banking Stress Testing AI Assistant",layout="wide")
st.title("Banking Stress Testing AI Assistant")
uploaded_file = st.file_uploader(
    "Upload Portfolio CSV",
    type=["csv"]
)

if uploaded_file is not None:
    portfolio_df = pd.read_csv(uploaded_file)

    st.subheader("Uploaded Portfolio")

    st.dataframe(portfolio_df)
st.info("Python calculates PD, LGD, EAD and ECL. Azure OpenAI explains validated results only.")
with st.sidebar:
    score=st.slider("Credit score",300,900,680); balance=st.number_input("Outstanding balance (INR)",min_value=1.0,value=1000000.0)
    product=st.selectbox("Product",list(BASE_LGD)); scenario=st.selectbox("Scenario",list(SCENARIOS),index=2); run=st.button("Run stress test",type="primary")
if run:
    r=calculate_stress(score,balance,product,scenario); d=r.to_dict(); c1,c2,c3=st.columns(3)
    c1.metric("Risk segment",r.risk_segment); c2.metric("Base ECL",f"INR {r.base_ecl:,.2f}"); c3.metric("Stressed ECL",f"INR {r.stressed_ecl:,.2f}")
    st.dataframe(pd.DataFrame([d]),use_container_width=True); st.subheader("AI explanation"); st.write(explain(d))
    st.download_button("Download CSV",pd.DataFrame([d]).to_csv(index=False),"stress_result.csv")
st.caption("Synthetic demonstration only. Not a production model or lending recommendation.")

