

onmessage = ({data})=>{
    console.log("webWorker.js : "+data);
    postMessage("world");
};