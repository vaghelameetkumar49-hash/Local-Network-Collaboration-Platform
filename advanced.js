/* Orbit Advanced Dashboard — works with the existing Supabase tables */
(()=> {
  const $=s=>document.querySelector(s);
  const esc=s=>String(s??"").replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
  let currentFilter="All", searchText="";
  function mount(){
    const app=$("#app"), main=app?.querySelector("main");
    if(!app||app.hidden||!main||$("#advancedOverview"))return;
    const nav=main.querySelector("nav");
    if(nav&&!nav.querySelector('[data-tab="overview"]')){
      const b=document.createElement("button");b.className="nav";b.dataset.tab="overview";b.textContent="Overview";
      nav.insertBefore(b,nav.firstChild);b.addEventListener("click",()=>show("overview"));
    }
    const overview=document.createElement("section");overview.id="advancedOverview";
    overview.innerHTML='<article class="adv-card"><h2>Workspace health</h2><div class="adv-muted">Live summary of your team workspace</div><div class="adv-progress"><span id="advProgress" style="width:0%"></span></div><b id="advProgressLabel">0% tasks completed</b><p class="adv-muted" id="advProjectLabel">Across 0 projects</p></article><article class="adv-card"><h3>Task insights</h3><div class="adv-kpis"><div class="adv-kpi"><span class="adv-muted">To do</span><b id="advTodo">0</b></div><div class="adv-kpi"><span class="adv-muted">In progress</span><b id="advDoing">0</b></div><div class="adv-kpi"><span class="adv-muted">Completed</span><b id="advDone">0</b></div><div class="adv-kpi"><span class="adv-muted">Team members</span><b id="advMembers">0</b></div></div></article>';
    const projects=$("#projectsTab");main.insertBefore(overview,projects);
    const tools=document.createElement("div");tools.className="adv-tools";tools.innerHTML='<input id="advSearch" type="search" placeholder="Search tasks or projects…"><select id="advFilter"><option>All</option><option>To do</option><option>In progress</option><option>Done</option></select>';
    const taskPanel=$("#tasksTab");if(taskPanel){const h=taskPanel.querySelector(".sectionhead");h?.after(tools);}
    $("#advSearch").addEventListener("input",e=>{searchText=e.target.value.toLowerCase();filterRows()});
    $("#advFilter").addEventListener("change",e=>{currentFilter=e.target.value;filterRows()});
    nav?.querySelectorAll(".nav").forEach(b=>{if(b.dataset.tab!=="overview")b.addEventListener("click",()=>show(b.dataset.tab))});
    update();show("overview");
  }
  function show(tab){["projects","tasks","team"].forEach(t=>{const el=$("#"+t+"Tab");if(el)el.hidden=t!==tab});const ov=$("#advancedOverview");if(ov)ov.hidden=tab!=="overview";const tools=document.querySelector(".adv-tools");if(tools)tools.hidden=tab!=="tasks";document.querySelectorAll(".nav").forEach(b=>b.classList.toggle("active",b.dataset.tab===tab));}
  function update(){
    if(!$("#advancedOverview")||typeof tasks==="undefined")return;
    const all=tasks||[],done=all.filter(t=>t.status==="Done").length,todo=all.filter(t=>t.status==="To do").length,doing=all.filter(t=>t.status==="In progress").length,pct=all.length?Math.round(done/all.length*100):0;
    $("#advProgress").style.width=pct+"%";$("#advProgressLabel").textContent=pct+"% tasks completed";$("#advProjectLabel").textContent="Across "+(projects?.length||0)+" projects";
    $("#advTodo").textContent=todo;$("#advDoing").textContent=doing;$("#advDone").textContent=done;$("#advMembers").textContent=members?.length||0;
    filterRows();
  }
  function filterRows(){document.querySelectorAll("#taskList tr").forEach(row=>{const status=row.querySelector("select")?.value||"";const matchStatus=currentFilter==="All"||status===currentFilter;const matchText=row.textContent.toLowerCase().includes(searchText);row.hidden=!(matchStatus&&matchText)});}
  const appNode=$("#app");
  const obs=new MutationObserver(()=>{if(appNode&&!appNode.hidden){mount();update()}});
  if(appNode)obs.observe(appNode,{attributes:true,attributeFilter:["hidden"]});
  document.addEventListener("click",e=>{if(e.target.closest("#addTask,#addProject"))setTimeout(update,200)});
  document.addEventListener("change",e=>{if(e.target.matches("[data-status]"))setTimeout(update,250)});
  // Re-render summary whenever the existing task/member lists update.
  const listObs=new MutationObserver(()=>update());
  const wait=()=>{const list=$("#taskList");if(list)listObs.observe(list,{childList:true,subtree:true,characterData:true});};
  wait();setTimeout(wait,800);
})();