<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>News</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
      padding: 0;
      background-color: #f4f4f4;
    }
    .container {
      max-width: 800px;
      margin: 0 auto;
      background: white;
      padding: 20px;
      border-radius: 5px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      position: relative;
    }
    .news-item {
      border-bottom: 1px solid #ddd;
      padding: 10px 0;
    }
    .news-item:last-child {
      border-bottom: none;
    }
    .loading {
      text-align: center;
      font-size: 16px;
      color: gray;
      margin-top: 20px;
    }
    /* Preferences Modal Styles */
    .modal {
      display: none; /* Hidden by default */
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background-color: rgba(0, 0, 0, 0.5); /* Black with opacity */
    }
    .modal-content {
      background-color: #fff;
      margin: 10% auto;
      padding: 20px;
      border-radius: 5px;
      width: 90%;
      max-width: 400px;
      position: relative;
    }
    .modal-header {
      margin-bottom: 15px;
    }
    .modal-header h2 {
      margin: 0;
    }
    .modal-body label {
      display: block;
      margin-bottom: 5px;
    }
    .modal-body input[type="range"] {
      width: 100%;
      margin-bottom: 5px;
    }
    .modal-body span {
      display: inline-block;
      margin-bottom: 15px;
      font-weight: bold;
    }
    .modal-footer {
      text-align: right;
    }
    .modal-footer button {
      padding: 8px 16px;
      margin-left: 10px;
    }
    /* Reset Preferences Button */
    #reset-preferences {
      position: absolute;
      top: 20px;
      right: 20px;
      background-color: #007BFF;
      color: #fff;
      border: none;
      padding: 8px 12px;
      border-radius: 3px;
      cursor: pointer;
    }
    #reset-preferences:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>
  
  <div class="container">
    <button id="reset-preferences">Set Preferences</button>
    <h2>Latest News</h2>
    <div id="news-container"></div>
    <div id="loading" class="loading">Loading more news...</div>
  </div>

  <!-- Preferences Modal -->
  <div id="preferences-modal" class="modal">
    <div class="modal-content">
      <div class="modal-header">
        <h2>Set Your Preferences</h2>
      </div>
      <div class="modal-body">
        <label for="importance-slider">Article Importance (1-10)</label>
        <input type="range" id="importance-slider" min="1" max="10" value="5" />
        <span id="importance-value">5</span>
        
        <label for="positivity-slider">Article Positivity (1-10)</label>
        <input type="range" id="positivity-slider" min="1" max="10" value="5" />
        <span id="positivity-value">5</span>
      </div>
      <div class="modal-footer">
        <button id="save-preferences">Save</button>
      </div>
    </div>
  </div>

  <script>
    // Simulated news data; each article has title, content, importance, and positivity.
    const newsData = ${JSON.stringify(articles)};
    let currentIndex = 0;
    const pageSize = 10;
    let isLoading = false;
    
    // Return filtered news based on saved user preferences.
    function getFilteredNewsData() {
      const stored = localStorage.getItem("newsPreferences");
      if (stored) {
        const prefs = JSON.parse(stored);
        return newsData.filter(item => {
          return item.importance >= prefs.importance && item.positivity >= prefs.positivity;
        });
      }
      return newsData.filter(item => {
          return item.importance >= 5 && item.positivity >= 5;
        });
    }
    
    // Load more news items with infinite scroll and filtering.
    function loadMoreNews() {
      if (isLoading) return;
      isLoading = true;
      document.getElementById("loading").style.display = "block";

      setTimeout(() => {
        const newsContainer = document.getElementById("news-container");
        const filteredNews = getFilteredNewsData();
        const nextBatch = filteredNews.slice(currentIndex, currentIndex + pageSize);

        // If no articles match the filter, display a message.
        if (filteredNews.length === 0 && currentIndex === 0) {
          newsContainer.innerHTML = "<p>No articles match your preferences.</p>";
          document.getElementById("loading").style.display = "none";
          window.removeEventListener("scroll", handleScroll);
          isLoading = false;
          return;
        }

        nextBatch.forEach(item => {
          const newsItem = document.createElement("div");
          newsItem.classList.add("news-item");
          newsItem.innerHTML = `<h3>${item.title}</h3><p>${item.content}</p>`;
          newsContainer.appendChild(newsItem);
        });

        currentIndex += pageSize;
        isLoading = false;

        if (currentIndex >= filteredNews.length) {
          document.getElementById("loading").style.display = "none";
          window.removeEventListener("scroll", handleScroll);
        }
      }, 1000); // Simulating a delay
    }

    function handleScroll() {
      if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 200) {
        loadMoreNews();
      }
    }

    // Refresh the news list when preferences change.
    function refreshNews() {
      currentIndex = 0;
      document.getElementById("news-container").innerHTML = "";
      document.getElementById("loading").style.display = "block";
      window.addEventListener("scroll", handleScroll);
      loadMoreNews();
    }

    // Load initial news items.
    loadMoreNews();
    window.addEventListener("scroll", handleScroll);

    // Preferences Modal Logic
    const preferencesModal = document.getElementById("preferences-modal");
    const importanceSlider = document.getElementById("importance-slider");
    const positivitySlider = document.getElementById("positivity-slider");
    const importanceValue = document.getElementById("importance-value");
    const positivityValue = document.getElementById("positivity-value");
    const savePreferencesBtn = document.getElementById("save-preferences");
    const resetPreferencesBtn = document.getElementById("reset-preferences");

    importanceSlider.addEventListener("input", () => {
      importanceValue.textContent = importanceSlider.value;
    });
    positivitySlider.addEventListener("input", () => {
      positivityValue.textContent = positivitySlider.value;
    });

    function showPreferencesModal() {
      preferencesModal.style.display = "block";
    }

    function hidePreferencesModal() {
      preferencesModal.style.display = "none";
    }

    // Save preferences and refresh the news list.
    function savePreferences() {
      const preferences = {
        importance: importanceSlider.value,
        positivity: positivitySlider.value,
        timestamp: new Date().getTime()
      };
      localStorage.setItem("newsPreferences", JSON.stringify(preferences));
      refreshNews();
    }

    // Load stored preferences (if available) and update the slider values.
    function loadPreferences() {
      const stored = localStorage.getItem("newsPreferences");
      if (stored) {
        const prefs = JSON.parse(stored);
        importanceSlider.value = prefs.importance;
        positivitySlider.value = prefs.positivity;
        importanceValue.textContent = prefs.importance;
        positivityValue.textContent = prefs.positivity;
        return true;
      }
      return false;
    }

    // After 20 seconds, if no preferences have been set, show the modal.
    window.addEventListener("load", () => {
      if (!loadPreferences()) {
        setTimeout(() => {
          if (!localStorage.getItem("newsPreferences")) {
            showPreferencesModal();
          }
        }, 20000);
      }
    });

    savePreferencesBtn.addEventListener("click", () => {
      savePreferences();
      hidePreferencesModal();
    });

    // Reset preferences, show the modal, and refresh news.
    resetPreferencesBtn.addEventListener("click", () => {
      showPreferencesModal();
    });

    // Allow closing the modal by clicking outside the modal content.
    window.addEventListener("click", (event) => {
      if (event.target == preferencesModal) {
        hidePreferencesModal();
      }
    });
  </script>
</body>
</html>
