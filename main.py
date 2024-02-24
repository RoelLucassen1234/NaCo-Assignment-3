import pandas as pd
from sklearn.metrics import roc_auc_score, roc_curve
import matplotlib.pyplot as plt
# Combine anomaly scores for each value of r


for r in range(1, 10):
    english_scores = pd.read_csv(f'r{r}_english.txt', header=None, names=['Score'])
    tagalog_scores = pd.read_csv(f'r{r}_tagalog.txt', header=None, names=['Score'])

    # Add labels (0 for English, 1 for Tagalog)
    english_scores['Label'] = 0
    tagalog_scores['Label'] = 1

    # Concatenate scores
    combined_scores = pd.DataFrame()
    combined_scores = pd.concat([combined_scores, english_scores, tagalog_scores], ignore_index=True)

    # Read combined anomaly scores
    data = combined_scores

    # Compute ROC curve
    fpr, tpr, thresholds = roc_curve(data["Label"], data["Score"])

    # Compute AUC
    auc_value = roc_auc_score(data["Label"], data["Score"])
    print(f"AUC R{r}:", auc_value)

    # Plot ROC curve
    plt.figure(figsize=(4, 6))
    plt.plot(fpr, tpr, label=f'AUC={auc_value:.2f}')
    plt.plot([0, 1], [0, 1], linestyle='--', color='gray', label='Random')
    plt.xlabel('False Positive Rate')
    plt.ylabel('True Positive Rate')
    plt.title(f'ROC Curve {r}')
    plt.legend(loc='lower right')
    plt.grid(True)
    plt.show()

# Sort the combined scores by anomaly score
combined_scores = combined_scores.sort_values(by='Score')