"""
Gaming & Mental Health Dashboard - Fixed Version
All data is loaded from the real CSV file instead of using np.random
"""
import streamlit as st
import plotly.express as px
import pandas as pd
import numpy as np
import os

# ==================== PAGE CONFIG ====================
st.set_page_config(page_title="Gaming & Mental Health Analytics", layout="wide")

# ==================== CSS STYLING ====================
st.markdown("""
    <style>
        /* Default base font size */
        html, body {
            font-size: 14px !important;
        }
        
        /* Allow scrolling for mobile */
        html, body, [data-testid="stAppViewContainer"], [data-testid="stMainBlockContainer"] {
            overflow: auto !important;
        }

        /* Responsive Streamlit container padding */
        .block-container {
            padding-top: 2rem !important;
            padding-bottom: 1rem !important;
            max-width: 95% !important;
        }

        .stApp {
            background-color: #0f1123;
        }
        [data-testid="stSidebar"] {
            background-color: #1b1e3d !important;
            border-right: 1px solid #2d315a;
        }
        /* Remove sidebar top padding */
        [data-testid="stSidebar"] [data-testid="stSidebarUserContent"], 
        [data-testid="stSidebar"] > div:first-child {
            padding-top: 0vh !important;
        }
        h1, h2, h3, h4, h5, h6, p, label, .stMarkdown, stText {
            color: #FFFFFF !important;
            font-weight: bold !important;
            font-family: 'Arial', sans-serif !important;
        }
        .kpi-card {
            background-color: #1b1e3d;
            border-radius: 15px;
            padding: 10px;
            text-align: center;
            border: 1px solid #3b3f6c;
            box-shadow: 0 4px 15px rgba(0,0,0,0.4);
            margin-bottom: 5px !important;
        }
        .kpi-title {
            color: #a4a9d6 !important;
            font-size: 12px !important;
            font-weight: bold !important;
            margin-bottom: 2px;
        }
        .kpi-value {
            color: #FFFFFF !important;
            font-size: 20px !important;
            font-weight: bold !important;
        }
    </style>
""", unsafe_allow_html=True)

# ==================== LOAD REAL CSV DATA ====================
@st.cache_data
def load_data():
    csv_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'Gaming and Mental Health.csv')
    df = pd.read_csv(csv_path)

    # Compute derived columns
    df['Age_Group'] = df['age'].apply(
        lambda age: 'Teenager' if age <= 18 else 'Young_adult' if age <= 28 else 'Adult'
    )
    df['Physical_Pain'] = df.apply(
        lambda row: 'High_Risk' if row['eye_strain'] and row['back_neck_pain'] else 
                    'Moderate' if row['eye_strain'] or row['back_neck_pain'] else 'No_Risk',
        axis=1
    )
    df['Educational_State'] = df.apply(
        lambda row: 'Working_student' if pd.notna(row['grades_gpa']) and pd.notna(row['work_productivity_score']) else 
                    'Student' if pd.notna(row['grades_gpa']) else 
                    'Worker' if pd.notna(row['work_productivity_score']) else 'Unknown',
        axis=1
    )
    
    # Calculate categories
    df['Spend_Category'] = pd.qcut(df['monthly_game_spending_usd'], q=4, labels=['Low', 'Mid', 'High', 'Very High'])
    df['Gaming_Hours_Category'] = df['daily_gaming_hours'].apply(
        lambda x: 'Low' if x <= 3 else 'Medium' if x <= 7 else 'High'
    )

    # Build unified DataFrame with renamed columns
    df_base = pd.DataFrame({
        'Educational_State': df['Educational_State'],
        'Age_Group': df['Age_Group'],
        'Age': df['age'],
        'gender': df['gender'],
        'gaming_platform': df['gaming_platform'],
        'gaming_addiction_risk': df['gaming_addiction_risk_level'],
        'mood_swing_frequency': df['mood_swing_frequency'],
        'Physical_Pain': df['Physical_Pain'],
        'Mood_State': df['mood_state'],
        'Game': df['primary_game'],
        'Genre': df['game_genre'],
        'F2F_Social_Hours': df['face_to_face_social_hours_weekly'],
        'Social_Score': df['social_isolation_score'],
        'Work_Productivity': df['work_productivity_score'].fillna(df['work_productivity_score'].mean()),
        'Daily_Gaming_Hours': df['daily_gaming_hours'],
        'Exercise_Hours': df['exercise_hours_weekly'],
        'Sleep_Hours': df['sleep_hours'],
        'Sleep_Quality': df['sleep_quality'],
        'GPA': df['grades_gpa'].fillna(df['grades_gpa'].mean()),
        'Total_Spent': df['monthly_game_spending_usd'],
        'Spend_Category': df['Spend_Category'],
        'Gaming_Hours_Category': df['Gaming_Hours_Category']
    })
    
    df_base['Mood_State'] = df_base['Mood_State'].astype(str).str.title()
    df_base['gaming_addiction_risk'] = df_base['gaming_addiction_risk'].astype(str).str.title()

    mood_order = ["Excited", "Euphoric", "Enphoric", "Normal", "Restless", "Irritable", "Angry", "Withdrawn", "Withdraw", "Anxious", "Depressed"]
    risk_order = ["Low", "Moderate", "High", "Severe"]
    
    df_base['Mood_State'] = pd.Categorical(df_base['Mood_State'], categories=[m for m in mood_order if m in df_base['Mood_State'].unique()], ordered=True)
    df_base['gaming_addiction_risk'] = pd.Categorical(df_base['gaming_addiction_risk'], categories=[r for r in risk_order if r in df_base['gaming_addiction_risk'].unique()], ordered=True)

    return df_base

df_base = load_data()

# Filter value lists from real data
addiction_levels = list(df_base['gaming_addiction_risk'].dropna().unique())
age_groups = ['Teenager', 'Young_adult', 'Adult']
genders = sorted(df_base['gender'].dropna().unique().tolist())
frequencies = sorted(df_base['mood_swing_frequency'].dropna().unique().tolist())
physical_pain_levels = sorted(df_base['Physical_Pain'].unique().tolist())
moods = list(df_base['Mood_State'].dropna().unique())
gaming_platforms = sorted(df_base['gaming_platform'].dropna().unique().tolist())

# ==================== COLOR THEME ====================
TEXT_COLOR = "#FFFFFF"
COLOR_HIGH = "#40a6ce"
COLOR_LOW = "#e019b2"
COLOR_MOD = "#5171e6"
COLOR_SEVERE = "#129fa1"
COLOR_BAR_PINK = "#e019b2"
COLOR_BAR_BLUE = "#40a6ce"
COLOR_THIRD = "#5171e6"
COLOR_FOURTH = "#129fa1"

def apply_chart_theme(fig):
    fig.update_layout(
        height=220,
        paper_bgcolor='rgba(0,0,0,0)',
        plot_bgcolor='rgba(0,0,0,0)',
        font=dict(color=TEXT_COLOR, family="Arial", size=10),
        title_font=dict(color=TEXT_COLOR, size=13, family="Arial"),
        legend=dict(font=dict(color=TEXT_COLOR), title_font=dict(color=TEXT_COLOR)),
        margin=dict(l=30, r=20, t=30, b=20)
    )
    fig.update_xaxes(gridcolor='#2d315a', title_font=dict(color=TEXT_COLOR, size=14, weight='bold'), tickfont=dict(color=TEXT_COLOR, weight='bold'))
    fig.update_yaxes(gridcolor='#2d315a', title_font=dict(color=TEXT_COLOR, size=14, weight='bold'), tickfont=dict(color=TEXT_COLOR, weight='bold'))
    return fig

# ==================== SIDEBAR ====================
st.markdown("<h1 style='font-size: 22px;'>🎮 Gaming & Mental Health Dashboard</h1>", unsafe_allow_html=True)

with st.sidebar:
    st.markdown("<h2 style='text-align: center; font-size: 18px;'>Navigation & Filters</h2>", unsafe_allow_html=True)
    
    # Dashboard selector
    selected_dashboard = st.selectbox("Select Dashboard", ["Player Dashboard", "Addiction Dashboard", "Health Dashboard"])
    st.markdown("<hr>", unsafe_allow_html=True)

    with st.form("filter_form"):
        with st.expander("🎯 Addiction Risk Level"):
            risk_checks = {r: st.checkbox(r, value=True, key=f"ar_{r}") for r in addiction_levels}

        with st.expander("👤 Age Group"):
            age_checks = {a: st.checkbox(a, value=True, key=f"ag_{a}") for a in age_groups}

        with st.expander("⚧ Gender"):
            gender_checks = {g: st.checkbox(g, value=True, key=f"g_{g}") for g in genders}

        with st.expander("🧠 Mood Swing Frequency"):
            freq_checks = {f: st.checkbox(f, value=True, key=f"ms_{f}") for f in frequencies}

        applied = st.form_submit_button("✅ Apply Filters", use_container_width=True)

    selected_ar = [r for r, checked in risk_checks.items() if checked]
    selected_ag = [a for a, checked in age_checks.items() if checked]
    selected_g = [g for g, checked in gender_checks.items() if checked]
    selected_ms = [f for f, checked in freq_checks.items() if checked]

# Filter fallback (if nothing selected, show all)
if not selected_ar: selected_ar = addiction_levels
if not selected_ag: selected_ag = age_groups
if not selected_g: selected_g = genders
if not selected_ms: selected_ms = frequencies

df_filtered = df_base[
    (df_base['gaming_addiction_risk'].isin(selected_ar)) &
    (df_base['Age_Group'].isin(selected_ag)) &
    (df_base['gender'].isin(selected_g)) &
    (df_base['mood_swing_frequency'].isin(selected_ms))
]

# ==================== DASHBOARDS ====================

if selected_dashboard == "Player Dashboard":
    st.markdown("<h2 style='font-size: 20px;'>Player DashBoard</h2>", unsafe_allow_html=True)
    pass
    
    if len(df_filtered) > 0:
        val_players = f"{len(df_filtered)}"
        val_age = f"{df_filtered['Age'].mean():.1f}"
        val_spending = f"${df_filtered['Total_Spent'].mean():.2f}"
        val_gaming = f"{df_filtered['Daily_Gaming_Hours'].mean():.1f}"
    else:
        val_players = val_age = val_spending = val_gaming = "0"
        
    kpi_col1, kpi_col2, kpi_col3, kpi_col4 = st.columns(4)
    with kpi_col1:
        st.markdown(f'<div class="kpi-card"><div class="kpi-title">👥 Total Players</div><div class="kpi-value">{val_players}</div></div>', unsafe_allow_html=True)
    with kpi_col2:
        st.markdown(f'<div class="kpi-card"><div class="kpi-title">🎂 AVG Age</div><div class="kpi-value">{val_age}</div></div>', unsafe_allow_html=True)
    with kpi_col3:
        st.markdown(f'<div class="kpi-card"><div class="kpi-title">💰 AVG Monthly Spending</div><div class="kpi-value">{val_spending}</div></div>', unsafe_allow_html=True)
    with kpi_col4:
        st.markdown(f'<div class="kpi-card"><div class="kpi-title">🎮 AVG Daily Gaming Hours</div><div class="kpi-value">{val_gaming}</div></div>', unsafe_allow_html=True)

    pass
    
    r1_c1, r1_c2 = st.columns(2)
    with r1_c1:
        if len(df_filtered) > 0:
            df_gender = df_filtered.groupby('gender').size().reset_index(name='count')
            fig = px.pie(df_gender, values='count', names='gender', 
                         color_discrete_sequence=[COLOR_BAR_PINK, COLOR_BAR_BLUE, COLOR_THIRD])
            apply_chart_theme(fig)
            fig.update_layout(title="<b>Gender Distribution</b>", showlegend=False)
            fig.update_traces(textinfo='percent+label', hole=0.3, textposition='outside', textfont_size=12)
            st.plotly_chart(fig, use_container_width=True)
            
    with r1_c2:
        if len(df_filtered) > 0:
            df_genre = df_filtered.groupby('Genre')['Total_Spent'].sum().reset_index().sort_values(by='Total_Spent', ascending=True)
            fig = px.bar(df_genre, x='Total_Spent', y='Genre', orientation='h', color_discrete_sequence=[COLOR_BAR_BLUE])
            apply_chart_theme(fig)
            fig.update_layout(title="<b>Game Genre by Total Spend</b>", xaxis_title="Total Spending", yaxis_title="Game Genre")
            st.plotly_chart(fig, use_container_width=True)
            
    r2_c1, r2_c2 = st.columns(2)
    with r2_c1:
        if len(df_filtered) > 0:
            df_age = df_filtered.groupby('Age_Group')['Daily_Gaming_Hours'].sum().reset_index()
            fig = px.pie(df_age, values='Daily_Gaming_Hours', names='Age_Group', 
                         color_discrete_sequence=[COLOR_BAR_PINK, COLOR_BAR_BLUE, COLOR_THIRD])
            apply_chart_theme(fig)
            fig.update_layout(title="<b>Gaming Hours by Age Group</b>", showlegend=False)
            fig.update_traces(textinfo='percent+label', hole=0.3, textposition='outside', textfont_size=12)
            st.plotly_chart(fig, use_container_width=True)
            
    with r2_c2:
        if len(df_filtered) > 0:
            df_top_games = df_filtered.groupby('Game')['Daily_Gaming_Hours'].mean().reset_index().nlargest(5, 'Daily_Gaming_Hours').sort_values(by='Daily_Gaming_Hours', ascending=True)
            fig = px.bar(df_top_games, x='Daily_Gaming_Hours', y='Game', orientation='h', color_discrete_sequence=[COLOR_THIRD])
            apply_chart_theme(fig)
            fig.update_layout(title="<b>Top 5 Games by Daily Gaming Hours</b>", xaxis_title="Avg Daily Gaming Hours", yaxis_title="Game")
            st.plotly_chart(fig, use_container_width=True)

elif selected_dashboard == "Addiction Dashboard":
    st.markdown("<h2 style='font-size: 20px;'>Addiction DashBoard</h2>", unsafe_allow_html=True)
    pass

    if len(df_filtered) > 0:
        val_f2f = f"{df_filtered['F2F_Social_Hours'].mean():.1f}"
        val_social = f"{df_filtered['Social_Score'].mean():.1f}"
        val_prod = f"{df_filtered['Work_Productivity'].mean():.1f}"
        val_gaming = f"{df_filtered['Daily_Gaming_Hours'].mean():.1f}"
    else:
        val_f2f = val_social = val_prod = val_gaming = "0.0"

    kpi_col1, kpi_col2, kpi_col3, kpi_col4 = st.columns(4)
    with kpi_col1:
        st.markdown(f'<div class="kpi-card"><div class="kpi-title">👥 F2F Social Hours</div><div class="kpi-value">{val_f2f}</div></div>', unsafe_allow_html=True)
    with kpi_col2:
        st.markdown(f'<div class="kpi-card"><div class="kpi-title">📊 AVG of social score</div><div class="kpi-value">{val_social}</div></div>', unsafe_allow_html=True)
    with kpi_col3:
        st.markdown(f'<div class="kpi-card"><div class="kpi-title">💻 AVG work productivity</div><div class="kpi-value">{val_prod}</div></div>', unsafe_allow_html=True)
    with kpi_col4:
        st.markdown(f'<div class="kpi-card"><div class="kpi-title">🎮 AVG Daily Gaming Hours</div><div class="kpi-value">{val_gaming}</div></div>', unsafe_allow_html=True)

    pass

    # Charts Row 1
    row1_col1, row1_col2 = st.columns(2)

    with row1_col1:
        if len(df_filtered) > 0:
            df_social_life = df_filtered.groupby('gaming_addiction_risk').agg({'Social_Score': 'mean', 'F2F_Social_Hours': 'mean'}).reset_index()
            df_melted = df_social_life.melt(id_vars='gaming_addiction_risk', value_vars=['Social_Score', 'F2F_Social_Hours'],
                                            var_name='Metric', value_name='Value')
            df_melted['Metric'] = df_melted['Metric'].replace({
                'Social_Score': 'Avg Social Isolation Score',
                'F2F_Social_Hours': 'Avg F2F Social Hours'
            })
            df_melted = df_melted.sort_values('gaming_addiction_risk')

            fig = px.bar(df_melted, x='gaming_addiction_risk', y='Value', color='Metric', barmode='group',
                                color_discrete_sequence=[COLOR_HIGH, COLOR_LOW])
            apply_chart_theme(fig)
            fig.update_layout(title=dict(text="<b>Addiction Risk by Social Metrics</b>", x=0.05), xaxis_title="Addiction Risk Level", yaxis_title="Avg Score", legend_title="")
            st.plotly_chart(fig, use_container_width=True, config={'displayModeBar': False})

    with row1_col2:
        if len(df_filtered) > 0:
            df_risk_spend = df_filtered.groupby('gaming_addiction_risk')['Total_Spent'].sum().reset_index()
            fig = px.pie(df_risk_spend, values='Total_Spent', names='gaming_addiction_risk', 
                         color_discrete_sequence=[COLOR_HIGH, COLOR_LOW, COLOR_MOD, COLOR_SEVERE])
            apply_chart_theme(fig)
            fig.update_layout(title="<b>Addiction Risk Level by Total Spend</b>", showlegend=False)
            fig.update_traces(textinfo='percent+label', hole=0.3, textposition='outside', textfont_size=12)
            st.plotly_chart(fig, use_container_width=True, config={'displayModeBar': False})

    # Charts Row 2
    row2_col1, row2_col2 = st.columns(2)

    with row2_col1:
        if len(df_filtered) > 0:
            df_mood_spend = df_filtered.groupby('Mood_State', observed=False)['Total_Spent'].mean().reset_index()
            fig = px.line(df_mood_spend, x='Mood_State', y='Total_Spent', color_discrete_sequence=[COLOR_HIGH], markers=True)
            apply_chart_theme(fig)
            fig.update_layout(title=dict(text="<b>Mood State by Total Spend</b>", x=0.05), xaxis_title="Mood State", yaxis_title="Avg Spend")
            fig.update_traces(line=dict(width=3))
            st.plotly_chart(fig, use_container_width=True, config={'displayModeBar': False})

    with row2_col2:
        if len(df_filtered) > 0:
            df_risk_hours = df_filtered.groupby('gaming_addiction_risk').agg({'Daily_Gaming_Hours': 'mean', 'Exercise_Hours': 'mean'}).reset_index()
            df_melted_hours = df_risk_hours.melt(id_vars='gaming_addiction_risk', value_vars=['Daily_Gaming_Hours', 'Exercise_Hours'],
                                            var_name='Metric', value_name='Hours')
            df_melted_hours = df_melted_hours.sort_values('gaming_addiction_risk')
    
            fig = px.line(df_melted_hours, x='gaming_addiction_risk', y='Hours', color='Metric', markers=True, color_discrete_sequence=[COLOR_HIGH, COLOR_LOW])
            apply_chart_theme(fig)
            fig.update_layout(title=dict(text="<b>Addiction Risk by Gaming & Exercise Hours</b>", x=0.05), xaxis_title="Addiction Risk Level", yaxis_title="Avg Hours", legend_title="")
            fig.update_traces(line=dict(width=3))
            st.plotly_chart(fig, use_container_width=True, config={'displayModeBar': False})

elif selected_dashboard == "Health Dashboard":
    st.markdown("<h2 style='font-size: 20px;'>Health DashBoard</h2>", unsafe_allow_html=True)
    pass

    # Health KPIs
    if len(df_filtered) > 0:
        val_exercise = f"{df_filtered['Exercise_Hours'].mean():.1f}"
        val_sleep = f"{df_filtered['Sleep_Hours'].mean():.0f}"
        val_gaming_hc = f"{df_filtered['Daily_Gaming_Hours'].mean():.4f}"
    else:
        val_exercise = "0.0"
        val_sleep = "0"
        val_gaming_hc = "0.0000"

    col1, col2, col3 = st.columns(3)
    with col1:
        st.markdown(f'<div class="kpi-card"><div class="kpi-title">🏋️ AVG of Exercise</div><div class="kpi-value">{val_exercise}</div></div>', unsafe_allow_html=True)
    with col2:
        st.markdown(f'<div class="kpi-card"><div class="kpi-title">💤 AVG Sleep hrs</div><div class="kpi-value">{val_sleep}</div></div>', unsafe_allow_html=True)
    with col3:
        st.markdown(f'<div class="kpi-card"><div class="kpi-title">🎮 Daily Gaming Hours</div><div class="kpi-value">{val_gaming_hc}</div></div>', unsafe_allow_html=True)

    r1_c1, r1_c2 = st.columns(2)
    with r1_c1:
        if len(df_filtered) > 0:
            df_pain_hours = df_filtered.groupby('Physical_Pain')['Daily_Gaming_Hours'].sum().reset_index()
            fig = px.pie(df_pain_hours, names='Physical_Pain', values='Daily_Gaming_Hours', hole=0.6,
                         color_discrete_sequence=[COLOR_BAR_PINK, COLOR_BAR_BLUE, COLOR_THIRD])
            apply_chart_theme(fig)
            fig.update_layout(title="<b>Physical Pain by Gaming Hours</b>", showlegend=False)
            fig.update_traces(textinfo='percent+label', textposition='outside', textfont_size=12)
            st.plotly_chart(fig, use_container_width=True)

    with r1_c2:
        if len(df_filtered) > 0:
            df_plat_pain = df_filtered.groupby(['gaming_platform', 'Physical_Pain']).size().reset_index(name='count')
            fig = px.bar(df_plat_pain, x='gaming_platform', y='count', color='Physical_Pain', barmode='group',
                         color_discrete_sequence=[COLOR_BAR_PINK, COLOR_BAR_BLUE, COLOR_THIRD])
            apply_chart_theme(fig)
            fig.update_layout(title="<b>Gaming Platform by Physical Pain</b>", xaxis_title="Gaming Platform", yaxis_title="Count", legend_title="")
            st.plotly_chart(fig, use_container_width=True)

    r2_c1, r2_c2 = st.columns(2)
    with r2_c1:
        if len(df_filtered) > 0:
            df_sleep_qual = df_filtered.groupby('Sleep_Quality')['Sleep_Hours'].mean().reset_index()
            fig = px.bar(df_sleep_qual, x='Sleep_Quality', y='Sleep_Hours', color_discrete_sequence=[COLOR_BAR_PINK])
            apply_chart_theme(fig)
            fig.update_layout(title="<b>Sleep Quality by Sleep Hours</b>", xaxis_title="Sleep Quality", yaxis_title="Avg Sleep Hours")
            st.plotly_chart(fig, use_container_width=True)

    with r2_c2:
        if len(df_filtered) > 0:
            df_cat_sleep = df_filtered.groupby('Gaming_Hours_Category', observed=False)['Sleep_Hours'].mean().reset_index()
            fig = px.bar(df_cat_sleep, x='Sleep_Hours', y='Gaming_Hours_Category', orientation='h', color_discrete_sequence=[COLOR_BAR_BLUE])
            apply_chart_theme(fig)
            fig.update_layout(title="<b>Gaming Hours Category by Avg Sleep Hours</b>", xaxis_title="Avg Sleep Hours", yaxis_title="Gaming Hours Category")
            st.plotly_chart(fig, use_container_width=True)

