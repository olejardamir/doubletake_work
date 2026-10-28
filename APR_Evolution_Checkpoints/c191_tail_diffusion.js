/* APR C191 original B152 source-only retrospective research; node c191_tail_diffusion.js PART1.json ... PART6.json */
const fs=require('fs');
function solveTail(diff,lambdaUp,lambdaDown,jumpUp,jumpDown,grid=100){
  const a=Math.log(.97),b=Math.log(1.05),h=(b-a)/grid,k=diff/(2*h*h),den=2*k+lambdaUp+lambdaDown;
  let f=Array.from({length:grid+1},(_,i)=>i/grid);
  function at(x){if(x<=a)return 0;if(x>=b)return 1;const z=(x-a)/h,j=Math.floor(z);return f[j]+(z-j)*(f[j+1]-f[j]);}
  let change=0,iterations=0;
  for(let t=0;t<12000;t++){change=0;for(let i=1;i<grid;i++){
    const x=a+i*h;
    const value=(k*(f[i-1]+f[i+1])+lambdaUp*at(x+jumpUp)+lambdaDown*at(x-jumpDown))/den;
    const next=f[i]+1.85*(value-f[i]);change=Math.max(change,Math.abs(next-f[i]));f[i]=next;
  }iterations=t+1;if(change<1e-10)break;}
  const q=at(0);
  if(!Number.isFinite(q)||q<0||q>1||change>=1e-10)throw Error("tail solver did not converge");
  return {q,iterations,change};
}
function forecast(item,days,shrink=0.5,neutral=false,grid=100){
  const ms=Date.parse(item.date+"T00:00:00Z");
  if(item.bars.length!==336||+item.endTime!==ms-1||+item.startTime!==ms-336*3600000)throw Error("source timing "+item.date+" "+item.asset);
  for(let j=0;j<336;j++)if(+item.bars[j][0]!==+item.startTime+j*3600000||+item.bars[j][6]!==+item.startTime+(j+1)*3600000-1)throw Error("source continuity");
  const closes=item.bars.slice(-days*24).map(x=>Math.log(+x[4]));
  const ret=closes.slice(1).map((x,i)=>x-closes[i]);
  const n=ret.length, rms=Math.sqrt(ret.reduce((s,x)=>s+x*x,0)/n),thr=2.5*rms;
  const up=ret.filter(x=>x>thr),down=ret.filter(x=>x<-thr);
  let lu=(up.length+0.5)/(n+1),ld=(down.length+0.5)/(n+1);
  const ju=up.length?up.reduce((s,x)=>s+x,0)/up.length:1.5*thr;
  const jd=down.length?-down.reduce((s,x)=>s+x,0)/down.length:1.5*thr;
  const diff=ret.filter(x=>Math.abs(x)<=thr).reduce((s,x)=>s+x*x,0)/n;
  const avg=(lu+ld)/2;lu=(1-shrink)*lu+shrink*avg;ld=(1-shrink)*ld+shrink*avg;
  const equalJ=(ju+jd)/2;
  const result=solveTail(diff,neutral?avg:lu,neutral?avg:ld,neutral?equalJ:ju,neutral?equalJ:jd,grid);
  return {q:result.q,iterations:result.iterations,convergence:result.change,n,threshold:thr,positive_jumps:up.length,negative_jumps:down.length,lambda_up:lu,lambda_down:ld,jump_up:ju,jump_down:jd,diffusion_variance:diff};
}
const paths=process.argv.slice(2);if(paths.length!==6)throw Error('Supply 6 B182 source part files');
const arrays=paths.flatMap(p=>JSON.parse(fs.readFileSync(p,'utf8')).source_arrays);
if(arrays.length!==66)throw Error('Expected 66 B152 arrays');
const rows=arrays.map(item=>({event_id:'B152_'+item.date+'_'+item.asset,date:item.date,asset:item.asset,q_tail_diffusion_14d:forecast(item,14,.5,false).q,q_symmetric_null_14d:forecast(item,14,.5,true).q,q_unshrunk_14d:forecast(item,14,0,false).q,q_tail_diffusion_7d:forecast(item,7,.5,false).q}));
console.log(JSON.stringify(rows,null,2));
