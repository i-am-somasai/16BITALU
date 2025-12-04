  # 🔥 Machine Learning–Based Dynamic Power Prediction for 16-bit ALU Architectures  
### *Hardware (RTL) + Switching Activity + ML Modeling*

---

## 🚀 Overview

This project builds a **complete RTL-to-ML pipeline** for predicting **dynamic power consumption** of 16-bit Arithmetic Logic Units (ALUs) using switching activity and architectural information.

The workflow includes:

- Verilog **RTL implementation** of multiple ALU architectures  
- Automated **CSV dataset generation** using testbenches  
- Extracting switching activity (Hamming weights, bit toggles, opcode behavior)  
- Training **ML regression models** to predict power  
- Comparing linear vs non-linear models  
- Fully visualizing model performance  

This project demonstrates how **machine learning can approximate hardware power behavior** using architectural features—without using full EDA power tools.

---

## 🧩 ALU Architectures Implemented (16-bit)

### **1. Ripple-Carry ALU (alu16_ripple.v)**
- Simple bitwise carry propagation  
- Lowest area, moderate switching  

### **2. Carry Lookahead ALU (alu16_cla.v)**
- Fast parallel carry generation  
- Higher internal switching activity  

### **3. Low-Power ALU (alu16_lowpower.v)**
- Clock-gated  
- Activity suppressed when `en = 0`  
- Lowest dynamic power  

All ALUs share:

- 4-bit opcode  
- 16-bit operands  
- Bitwise & arithmetic operations  
- Same CSV-logging interface  

---

## 📡 Dataset Generation

Each testbench logs one CSV row per cycle:

```
alu_id,bitwidth,opcode,a,b,a_hw,b_hw,y_toggles,en
```

Meaning:

| Column | Meaning |
|--------|---------|
| `alu_id` | 0=ripple, 1=CLA, 2=low-power |
| `bitwidth` | always `16` |
| `opcode` | ALU operation index |
| `a`, `b` | input operands |
| `a_hw`, `b_hw` | Hamming weights of inputs |
| `y_toggles` | bit flips on output compared to previous cycle |
| `en` | enable (low-power gating) |

### Example row:
```
2,16,5,1024,88,3,4,6,1
```

---

## 🔥 Power Modeling

A synthetic but hardware-aligned power formula:

```
power = alu_scale * (0.8*y_toggles + 0.1*a_hw + 0.1*b_hw)
power *= en
power += noise
```

Where:

| ALU Type | Scale |
|----------|-------|
| Ripple | 1.0 |
| CLA | 1.25 |
| Low-Power | 0.6 |

👉 This allows ML to **learn architecture effects**  
👉 Low-power ALU naturally shows lowest dynamic power  
👉 CLA shows highest due to internal G/P logic  

---

## 🤖 Machine Learning Models

Models trained using scikit-learn:

| Model | Characteristics |
|--------|---------------|
| **Linear Regression** | baseline |
| **Ridge Regression** | regularized linear model |
| **Lasso Regression** | feature sparsity |
| **Random Forest** | nonlinear ensemble, explains feature importance |
| **Gradient Boosting** | best accuracy |

### Example Results (Log-Transformed Target)

| Model | MAE | RMSE |
|--------|------|---------|
| Linear | 0.097 | 0.156 |
| Ridge | 0.099 | 0.157 |
| Lasso | 0.117 | 0.161 |
| Random Forest | 0.011 | 0.020 |
| **Gradient Boosting** | **0.007** | **0.010** |

👉 Non-linear models outperform linear models significantly  
👉 Gradient Boosting gives the best generalization  

---

## 📊 Visualizations Generated

- **Model Comparison (MAE/RMSE)**  
- **True vs Predicted Power — All Models**  
- **Prediction Error Scatterplots**  
- **Random Forest Feature Importance**  
- **Architectural Power Differences**  

These plots clearly show:

- Non-linearity in ALU behavior  
- Impact of toggles on dynamic power  
- CLA vs Ripple power differences  
- Low-power gating effects  

---

## 📁 Repository Structure

```
rtl/            # All Verilog RTL files
tb/             # Testbenches that generate CSV datasets
data/           # Output CSVs from simulation
ml/             # ML notebook, training scripts, plots
docs/           # Architecture notes & analysis
```

---

## 🛠 Tools & Dependencies

### Hardware Simulation
- **Vivado**, **Icarus Verilog**, or **ModelSim**

### Machine Learning
```
numpy
pandas
matplotlib
scikit-learn
```

## 🎯 Key Contributions

✔ Full RTL + ML workflow  
✔ Simulation-driven dataset creation  
✔ Architecture-aware power modeling  
✔ Low-power design analysis  
✔ ML-based power prediction  
✔ Model explainability (feature importance)  
✔ Clean, scalable dataset structure  

This project bridges **VLSI design** with **machine learning**, a highly valuable skillset for modern semiconductor engineering roles.

---

## 📌 Future Work
- Add 32-bit ALU version  
- Add internal-node switching estimation  
- Use XGBoost/LightGBM  
- Export trained model for hardware IP integration  
- Compare with PrimeTime PX (if accessible)  

---

## 🙌 Author

**Soma Sai**  
Electronics + VLSI + Machine Learning  
Verilog • RTL • ML for Hardware • Low-Power Design

---

