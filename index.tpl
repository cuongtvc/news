<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
    </style>
    <!-- Google Tag Manager -->
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
    'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
    })(window,document,'script','dataLayer','GTM-W9WTM4SP');</script>
    <!-- End Google Tag Manager -->
</head>
<body>
<!-- Google Tag Manager (noscript) -->
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-W9WTM4SP"
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
<!-- End Google Tag Manager (noscript) -->
<div class="container">
    <h2>Latest News</h2>
    <div id="news-container"></div>
    <div id="loading" class="loading">Loading more news...</div>
</div>

<script>
    const newsData = ${JSON.stringify(articles)};

    let currentIndex = 0;
    const pageSize = 10;
    let isLoading = false;
    
    function loadMoreNews() {
        if (isLoading) return; // Prevent multiple loads
        isLoading = true;
        document.getElementById("loading").style.display = "block";

        setTimeout(() => {
            const newsContainer = document.getElementById("news-container");
            const nextBatch = newsData.slice(currentIndex, currentIndex + pageSize);

            nextBatch.forEach(item => {
                const newsItem = document.createElement("div");
                newsItem.classList.add("news-item");
                newsItem.innerHTML = \`<h3>\${item.title}</h3><p>\${item.content}</p>\`;
                newsContainer.appendChild(newsItem);
            });

            currentIndex += pageSize;
            isLoading = false;

            // Hide loading text if all articles are loaded
            if (currentIndex >= newsData.length) {
                document.getElementById("loading").style.display = "none";
                window.removeEventListener("scroll", handleScroll); // Stop listening for scrolls
            }
        }, 1000); // Simulating a delay
    }

    function handleScroll() {
        if (window.innerHeight + window.scrollY >= document.body.offsetHeight - 200) {
            loadMoreNews();
        }
    }

    // Load initial news
    loadMoreNews();

    // Attach scroll event
    window.addEventListener("scroll", handleScroll);
</script>

</body>
</html>
