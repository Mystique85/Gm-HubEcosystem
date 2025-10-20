document.getElementById("connectBtn").addEventListener("click", async () => {
    if (!window.ethereum) return alert("Please install MetaMask!");
    await window.ethereum.request({ method: "eth_requestAccounts" });
    const provider = new ethers.BrowserProvider(window.ethereum);
    const signer = await provider.getSigner();
    console.log("Wallet connected:", await signer.getAddress());
});
