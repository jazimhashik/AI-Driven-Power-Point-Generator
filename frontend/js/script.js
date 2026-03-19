document.getElementById("pptForm").addEventListener("submit", function(e) {
    e.preventDefault();

    const content = document.getElementById("content").value;
    const slides = document.getElementById("slides").value;

    document.getElementById("loading").classList.remove("hidden");

    fetch("http://127.0.0.1:5000/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ content, slides })
    })
    .then(res => res.json())
    .then(data => {
        document.getElementById("loading").classList.add("hidden");

        if (data.file) {
            window.location.href = 
                `http://127.0.0.1:5000/download/${data.file}`;
        } else {
            alert("Error generating PPT");
        }
    })
    .catch(err => {
        document.getElementById("loading").classList.add("hidden");
        console.error(err);
    });
});
