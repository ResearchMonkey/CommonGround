// cg/icons.jsx — Outlined icon set (24px stroke). All icons are SVGs.
// Consistent stroke 1.75, currentColor.

const Icon = ({ d, size = 22, fill = false, stroke = 1.75, viewBox = '0 0 24 24', children, style }) => (
  <svg width={size} height={size} viewBox={viewBox} fill={fill ? 'currentColor' : 'none'}
    stroke="currentColor" strokeWidth={stroke} strokeLinecap="round" strokeLinejoin="round"
    style={style}>
    {d ? <path d={d} /> : children}
  </svg>
);

const Ic = {
  // HUD / nav
  crosshair: (p) => <Icon {...p}><circle cx="12" cy="12" r="7"/><path d="M12 2v3M12 19v3M2 12h3M19 12h3M12 12h.01"/></Icon>,
  pinPlus:   (p) => <Icon {...p}><path d="M12 21s-6-5.5-6-11a6 6 0 1 1 12 0c0 5.5-6 11-6 11Z"/><path d="M12 8v6M9 11h6"/></Icon>,
  layers:    (p) => <Icon {...p}><path d="m12 2 9 5-9 5-9-5 9-5Z"/><path d="m3 12 9 5 9-5"/><path d="m3 17 9 5 9-5"/></Icon>,
  search:    (p) => <Icon {...p}><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></Icon>,
  menu:      (p) => <Icon {...p}><path d="M4 7h16M4 12h16M4 17h16"/></Icon>,
  plus:      (p) => <Icon {...p}><path d="M12 5v14M5 12h14"/></Icon>,
  minus:     (p) => <Icon {...p}><path d="M5 12h14"/></Icon>,
  close:     (p) => <Icon {...p}><path d="m6 6 12 12M18 6 6 18"/></Icon>,
  chevDown:  (p) => <Icon {...p}><path d="m6 9 6 6 6-6"/></Icon>,
  chevRight: (p) => <Icon {...p}><path d="m9 6 6 6-6 6"/></Icon>,
  chevUp:    (p) => <Icon {...p}><path d="m6 15 6-6 6 6"/></Icon>,
  back:      (p) => <Icon {...p}><path d="M19 12H5M12 19l-7-7 7-7"/></Icon>,

  // Status / connection
  signal:    (p) => <Icon {...p}><path d="M2 22h2M7 22V14M12 22V8M17 22V14M22 22h-2"/></Icon>,
  signalMesh:(p) => <Icon {...p}><circle cx="5" cy="19" r="2"/><circle cx="12" cy="6" r="2"/><circle cx="19" cy="19" r="2"/><path d="m6.5 17.5 4-9.5M13.5 8l4 9.5M7 19h10"/></Icon>,
  signalOff: (p) => <Icon {...p}><path d="M2 22h20M5 19v-3M10 19v-7M15 19v-3"/><path d="m3 3 18 18" stroke="currentColor"/></Icon>,
  lock:      (p) => <Icon {...p}><rect x="5" y="11" width="14" height="10" rx="2"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/></Icon>,

  // Marker / map
  pin:       (p) => <Icon {...p}><path d="M12 21s-6-5.5-6-11a6 6 0 1 1 12 0c0 5.5-6 11-6 11Z"/><circle cx="12" cy="10" r="2"/></Icon>,
  pinFilled: (p) => <Icon {...p} fill><path d="M12 21s-6-5.5-6-11a6 6 0 1 1 12 0c0 5.5-6 11-6 11Z"/><circle cx="12" cy="10" r="2.2" fill="#0F1419"/></Icon>,
  eye:       (p) => <Icon {...p}><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/></Icon>,
  eyeOff:    (p) => <Icon {...p}><path d="M3 3l18 18M10.6 5.1A10.6 10.6 0 0 1 12 5c6.5 0 10 7 10 7a17.7 17.7 0 0 1-2.7 3.6M6.7 6.7C3.7 8.6 2 12 2 12s3.5 7 10 7c1.7 0 3.2-.4 4.5-1M9.9 9.9a3 3 0 0 0 4.2 4.2"/></Icon>,
  drag:      (p) => <Icon {...p}><circle cx="9" cy="6" r="1"/><circle cx="15" cy="6" r="1"/><circle cx="9" cy="12" r="1"/><circle cx="15" cy="12" r="1"/><circle cx="9" cy="18" r="1"/><circle cx="15" cy="18" r="1"/></Icon>,
  edit:      (p) => <Icon {...p}><path d="M12 20h9"/><path d="M16.5 3.5a2.1 2.1 0 0 1 3 3L7 19l-4 1 1-4Z"/></Icon>,
  share:     (p) => <Icon {...p}><circle cx="18" cy="5" r="2.5"/><circle cx="6" cy="12" r="2.5"/><circle cx="18" cy="19" r="2.5"/><path d="m8.2 10.8 7.6-4.4M8.2 13.2l7.6 4.4"/></Icon>,
  trash:     (p) => <Icon {...p}><path d="M3 6h18M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2M6 6l1 14a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2l1-14"/></Icon>,
  ruler:     (p) => <Icon {...p}><path d="m3 13 8-8 10 10-8 8-10-10Z"/><path d="m7 9 1 1M9 11l1 1M11 13l1 1M13 15l1 1M15 17l1 1"/></Icon>,
  filter:    (p) => <Icon {...p}><path d="M3 5h18l-7 9v6l-4-2v-4L3 5Z"/></Icon>,
  download:  (p) => <Icon {...p}><path d="M12 4v12M6 10l6 6 6-6M4 20h16"/></Icon>,
  upload:    (p) => <Icon {...p}><path d="M12 20V8M6 14l6-6 6 6M4 4h16"/></Icon>,
  star:      (p) => <Icon {...p}><path d="m12 3 2.7 6.1 6.6.6-5 4.5 1.5 6.5L12 17.3 6.2 20.7l1.5-6.5-5-4.5 6.6-.6L12 3Z"/></Icon>,
  settings:  (p) => <Icon {...p}><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1A2 2 0 1 1 4.4 17l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1 1.7 1.7 0 0 0-.3-1.8l-.1-.1a2 2 0 1 1 2.8-2.8l.1.1a1.7 1.7 0 0 0 1.8.3h.1a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1.7 1.7 0 0 0-.3 1.8v.1a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1Z"/></Icon>,
  plug:      (p) => <Icon {...p}><path d="M9 2v6M15 2v6M5 8h14v3a7 7 0 0 1-14 0V8ZM12 18v4"/></Icon>,
  info:      (p) => <Icon {...p}><circle cx="12" cy="12" r="9"/><path d="M12 8h.01M11 12h1v5h1"/></Icon>,
  check:     (p) => <Icon {...p}><path d="m4 12 5 5 11-11"/></Icon>,

  // Marker categories
  cross:     (p) => <Icon {...p}><path d="M9 3h6v6h6v6h-6v6H9v-6H3V9h6V3Z"/></Icon>,
  warning:   (p) => <Icon {...p}><path d="M12 3 2 20h20L12 3Z"/><path d="M12 10v4M12 17h.01"/></Icon>,
  flag:      (p) => <Icon {...p}><path d="M5 21V4M5 4h12l-3 4 3 4H5"/></Icon>,
  box:       (p) => <Icon {...p}><path d="m3 7 9-4 9 4-9 4-9-4Z"/><path d="m3 7v10l9 4 9-4V7"/><path d="M12 11v10"/></Icon>,
  user:      (p) => <Icon {...p}><circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0 1 16 0"/></Icon>,
  building:  (p) => <Icon {...p}><rect x="4" y="3" width="16" height="18" rx="1"/><path d="M9 7h.01M15 7h.01M9 11h.01M15 11h.01M9 15h.01M15 15h.01M10 21v-4h4v4"/></Icon>,
  truck:     (p) => <Icon {...p}><path d="M2 7h11v10H2zM13 10h5l3 3v4h-8z"/><circle cx="6" cy="18" r="2"/><circle cx="17" cy="18" r="2"/></Icon>,
  fire:      (p) => <Icon {...p}><path d="M12 3s5 4 5 9a5 5 0 0 1-10 0c0-2 1-3 1-3s1 2 3 2c0-3-2-4-2-7 0-1 1-1 3 0Z"/></Icon>,
  drop:      (p) => <Icon {...p}><path d="M12 3s7 7 7 12a7 7 0 0 1-14 0c0-5 7-12 7-12Z"/></Icon>,
};

Object.assign(window, { Icon, Ic });
