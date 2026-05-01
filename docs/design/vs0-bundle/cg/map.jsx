// cg/map.jsx — Topographic SVG map background.
// Stylized contour lines + terrain shading + rivers/roads, no real data.
// Generated procedurally so the map looks "alive" but stays performant.

function TopoMap({ width = 360, height = 800, seed = 7, roads = true, dim = 1 }) {
  // Build contour rings from a sum of sine fields. Cheap and looks tactical.
  const rings = React.useMemo(() => {
    const s = seed;
    const W = 100, H = 220;
    const sample = (x, y) =>
      Math.sin((x * 0.18) + s) * Math.cos((y * 0.13) - s * 0.7) +
      Math.sin((x * 0.07) + (y * 0.11) + s * 1.3) * 0.8 +
      Math.cos((x * 0.04) - (y * 0.06) + s * 0.4) * 1.1;
    // Grid of values
    const grid = [];
    for (let y = 0; y <= H; y += 2) {
      const row = [];
      for (let x = 0; x <= W; x += 2) row.push(sample(x, y));
      grid.push(row);
    }
    // Collect points above N thresholds; connect within row by simple span ranges
    const out = [];
    const levels = [-1.6, -1.0, -0.5, 0, 0.5, 1.0, 1.6, 2.1];
    levels.forEach((lvl, i) => {
      let path = '';
      // marching-squares-ish: just outline cells crossing threshold
      for (let y = 0; y < grid.length - 1; y++) {
        for (let x = 0; x < grid[0].length - 1; x++) {
          const a = grid[y][x], b = grid[y][x+1], c = grid[y+1][x], d = grid[y+1][x+1];
          const above = (v) => v > lvl;
          const k = (above(a)?1:0) + (above(b)?2:0) + (above(c)?4:0) + (above(d)?8:0);
          if (k === 0 || k === 15) continue;
          const px = x * 2, py = y * 2;
          // simplest: draw a tiny segment in the cell center
          path += `M${px+1} ${py+1} l1 1 `;
        }
      }
      out.push({ d: path, level: i, lvl });
    });
    return out;
  }, [seed]);

  return (
    <svg width={width} height={height} viewBox={`0 0 ${width} ${height}`}
      preserveAspectRatio="xMidYMid slice"
      style={{ position: 'absolute', inset: 0, display: 'block' }}>
      <defs>
        <linearGradient id={`tg-${seed}`} x1="0" y1="0" x2="0" y2="1">
          <stop offset="0%"  stopColor="#1B2A22"/>
          <stop offset="55%" stopColor="#152019"/>
          <stop offset="100%" stopColor="#0F1714"/>
        </linearGradient>
        <radialGradient id={`tv-${seed}`} cx="50%" cy="55%" r="75%">
          <stop offset="60%" stopColor="rgba(0,0,0,0)"/>
          <stop offset="100%" stopColor="rgba(0,0,0,0.45)"/>
        </radialGradient>
        <pattern id={`grid-${seed}`} width="40" height="40" patternUnits="userSpaceOnUse">
          <path d="M40 0H0V40" fill="none" stroke="rgba(232,234,237,0.04)" strokeWidth="1"/>
        </pattern>
      </defs>

      {/* base */}
      <rect width="100%" height="100%" fill={`url(#tg-${seed})`} />
      <rect width="100%" height="100%" fill={`url(#grid-${seed})`} />

      {/* contour lines (drawn at multiple thresholds) */}
      <g transform={`scale(${width/100} ${height/220})`} opacity={0.55 * dim}>
        {rings.map((r, i) => (
          <path key={i} d={r.d} fill="none"
            stroke={i === 4 ? 'rgba(180,200,180,0.55)' : 'rgba(140,170,150,0.32)'}
            strokeWidth={i === 4 ? 0.6 : 0.35}
            vectorEffect="non-scaling-stroke" />
        ))}
      </g>

      {/* river */}
      <path d={`M-10 ${height*0.32} C ${width*0.25} ${height*0.42}, ${width*0.4} ${height*0.5}, ${width*0.55} ${height*0.55} S ${width*0.85} ${height*0.78}, ${width+10} ${height*0.85}`}
        fill="none" stroke="#2C5878" strokeWidth="6" strokeLinecap="round" opacity="0.55"/>
      <path d={`M-10 ${height*0.32} C ${width*0.25} ${height*0.42}, ${width*0.4} ${height*0.5}, ${width*0.55} ${height*0.55} S ${width*0.85} ${height*0.78}, ${width+10} ${height*0.85}`}
        fill="none" stroke="#3F7AA0" strokeWidth="2.5" strokeLinecap="round" opacity="0.9"/>

      {/* roads */}
      {roads && (
        <g opacity={0.85 * dim}>
          <path d={`M-10 ${height*0.18} L ${width*0.4} ${height*0.25} L ${width*0.45} ${height*0.5} L ${width*0.6} ${height*0.65} L ${width+10} ${height*0.62}`}
            fill="none" stroke="rgba(220,210,180,0.42)" strokeWidth="1.6" strokeDasharray="6 4"/>
          <path d={`M${width*0.15} ${height+10} L ${width*0.22} ${height*0.7} L ${width*0.35} ${height*0.5} L ${width*0.4} ${height*0.25}`}
            fill="none" stroke="rgba(220,210,180,0.32)" strokeWidth="1.2" strokeDasharray="4 3"/>
          <path d={`M${width*0.7} -10 L ${width*0.62} ${height*0.18} L ${width*0.55} ${height*0.4} L ${width*0.6} ${height*0.65}`}
            fill="none" stroke="rgba(220,210,180,0.32)" strokeWidth="1.2" strokeDasharray="4 3"/>
        </g>
      )}

      {/* labels */}
      <g fontFamily="'IBM Plex Mono', monospace" fontSize="8" fill="rgba(200,210,200,0.4)" letterSpacing="1">
        <text x={width*0.12} y={height*0.16}>RIDGE 412</text>
        <text x={width*0.55} y={height*0.45}>VALLEY</text>
        <text x={width*0.18} y={height*0.78}>SEC 7B</text>
      </g>

      {/* vignette */}
      <rect width="100%" height="100%" fill={`url(#tv-${seed})`} />
    </svg>
  );
}

Object.assign(window, { TopoMap });
