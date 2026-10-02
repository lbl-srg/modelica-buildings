#!/usr/bin/env python3
"""Compare HardCase* base run with its variants.

The base run is drawn solid and is always shown; the variant compared against
it is drawn dotted and picked from the dropdown in the page header, in the
Dash app and in the static HTML alike.  Every variant is loaded into the
figure, so the dropdown switches between them without reloading any data.
Panels can be folded away individually, in both too.

The result files are the Dymola names of
Buildings.Templates.Plants.Chillers.Validation.HardCase1 and its variants.

    python3 plot_compare_hardcase.py           # Dash app on 127.0.0.1:8052
    python3 plot_compare_hardcase.py --html    # static HTML, no server needed
"""
import json
import sys
from html import escape

sys.path.insert(0, "/home/reituag/gitrepo/BuildingsPy")

import plotly.graph_objects as go
from buildingspy.io.outputfile import Reader
from plotly.subplots import make_subplots

RUN_A = ("Base", "HardCase1_dassl_chiller.mat")
# The variants the base run can be compared against, in dropdown order.
RUNS_B = {
    "Compliance": "HardCase1Compliance_chiller.mat",
    "Leakage": "HardCase1Leakage_chiller.mat",
    "Linearized": "HardCase1Linearized_chiller.mat",
}
DEFAULT_B = next(iter(RUNS_B))

OUT = "compare.html"
PORT = 8052

K = 273.15

# Panels: (title, unit, kind, [(variable, legend name[, lane label]), ...], offset, scale)
# kind: "lin" continuous, "stp" stepped, "bin" stepped binary shown as a
# timing diagram with one lane per signal.
PANELS = [
    ("Outdoor air temperature and lockout", "°C", "lin", [
        ("pla.ctl.ctl.TOut", "TOut"),
        ("pla.ctl.dat.TOutChiWatLck", "TOutChiWatLck"),
    ], -K, 1),
    ("Capacity requirement vs. installed capacity", "kW", "lin", [
        ("pla.ctl.ctl.staSetCon.capReq.y", "capReq.y"),
        ("pla.cap_nominal", "cap_nominal"),
    ], 0, 1e-3),
    ("Load signals", "1", "lin", [
        ("loa.u", "loa.u"),
        ("loa.yLoa_actual", "loa.yLoa_actual"),
        ("loa.yVal_actual", "loa.yVal_actual"),
    ], 0, 1),
    ("Plant and reset requests", "count", "stp", [
        ("pla.ctl.reqPlaChiWat.y", "reqPlaChiWat"),
        ("pla.ctl.reqResChiWat.y", "reqResChiWat"),
    ], 0, 1),
    ("Plant enable", "", "bin", [
        ("pla.ctl.ctl.plaEna.yPla", "plaEna.yPla", "Pla"),
    ], 0, 1),
    ("Stage index", "stage", "stp", [
        ("pla.ctl.ctl.staSetCon.ySta", "staSetCon.ySta"),
    ], 0, 1),
    ("Chiller enable", "", "bin", [
        ("pla.bus.chi[1].y1", "chi[1].y1", "[1]"),
        ("pla.bus.chi[2].y1", "chi[2].y1", "[2]"),
    ], 0, 1),
    ("Chiller CHW isolation valve command", "1", "lin", [
        ("pla.bus.valChiWatChiIso[1].y", "valChiWatChiIso[1]"),
        ("pla.bus.valChiWatChiIso[2].y", "valChiWatChiIso[2]"),
    ], 0, 1),
    ("Chiller CW isolation valve command", "1", "lin", [
        ("pla.bus.valConWatChiIso[1].y", "valConWatChiIso[1]"),
        ("pla.bus.valConWatChiIso[2].y", "valConWatChiIso[2]"),
    ], 0, 1),
    ("Primary CHW pump enable", "", "bin", [
        ("pla.bus.pumChiWatPri.y1[1]", "pumChiWatPri.y1[1]", "[1]"),
        ("pla.bus.pumChiWatPri.y1[2]", "pumChiWatPri.y1[2]", "[2]"),
    ], 0, 1),
    ("CW pump enable", "", "bin", [
        ("pla.bus.pumConWat.y1[1]", "pumConWat.y1[1]", "[1]"),
        ("pla.bus.pumConWat.y1[2]", "pumConWat.y1[2]", "[2]"),
    ], 0, 1),
    ("Primary CHW pump speed", "1", "lin", [
        ("pla.bus.pumChiWatPri.y", "pumChiWatPri.y"),
    ], 0, 1),
    ("Remote differential pressure", "kPa", "lin", [
        ("pla.bus.dpChiWatRem[1]", "dpChiWatRem[1]"),
        ("pla.ctl.resDpChiWatLoc.dpChiWatSet_remote[1]", "dpChiWatSet_remote[1]"),
    ], 0, 1e-3),
    ("Local differential pressure", "kPa", "lin", [
        ("pla.ctl.ctl.chiWatPumCon.dpChiWat_local", "dpChiWat_local"),
        ("pla.ctl.resDpChiWatLoc.dpChiWatSet_local", "dpChiWatSet_local"),
    ], 0, 1e-3),
    ("Primary CHW volume flow rate", "L/s", "lin", [
        ("pla.bus.VChiWatPri_flow", "VChiWatPri_flow"),
        ("datAll.pla.ctl.VChiWatPri_flow_nominal", "VChiWatPri_flow_nominal"),
    ], 0, 1e3),
    ("Chiller part load ratio", "1", "lin", [
        ("pla.chi.chi[1].chi.PLR", "chi[1].PLR"),
        ("pla.chi.chi[2].chi.PLR", "chi[2].PLR"),
    ], 0, 1),
    ("Chiller power", "kW", "lin", [
        ("pla.chi.chi[1].chi.P", "chi[1].P"),
        ("pla.chi.chi[2].chi.P", "chi[2].P"),
    ], 0, 1e-3),
    ("Primary CHW pump power", "kW", "lin", [
        ("pla.pumChiWatPri.pum[1].P", "pumChiWatPri[1].P"),
        ("pla.pumChiWatPri.pum[2].P", "pumChiWatPri[2].P"),
    ], 0, 1e-3),
    ("CW pump power", "kW", "lin", [
        ("pla.pumConWat.pum[1].P", "pumConWat[1].P"),
        ("pla.pumConWat.pum[2].P", "pumConWat[2].P"),
    ], 0, 1e-3),
    ("Cooling tower fan power", "kW", "lin", [
        ("pla.coo.coo[1].tow.PFan", "coo[1].PFan"),
        ("pla.coo.coo[2].tow.PFan", "coo[2].PFan"),
    ], 0, 1e-3),
    ("Chiller CHW isolation valve flow", "kg/s", "lin", [
        ("pla.chi.valChiWatChiIsoPar[1].m_flow", "valChiWatChiIsoPar[1]"),
        ("pla.chi.valChiWatChiIsoPar[2].m_flow", "valChiWatChiIsoPar[2]"),
    ], 0, 1),
    ("Chiller CW isolation valve flow", "kg/s", "lin", [
        ("pla.chi.valConWatChiIso[1].m_flow", "valConWatChiIso[1]"),
        ("pla.chi.valConWatChiIso[2].m_flow", "valConWatChiIso[2]"),
    ], 0, 1),
    ("Primary CHW pump check valve flow", "kg/s", "lin", [
        ("pla.pumChiWatPri.valChe[1].m_flow", "valChe[1]"),
        ("pla.pumChiWatPri.valChe[2].m_flow", "valChe[2]"),
    ], 0, 1),
    ("Chiller bypass and economizer flow", "kg/s", "lin", [
        ("pla.intChi.valChiWatChiBypPar.m_flow", "valChiWatChiBypPar"),
        ("pla.eco.valChiWatByp.m_flow", "eco.valChiWatByp"),
        ("pla.eco.valConWatIso.m_flow", "eco.valConWatIso"),
    ], 0, 1),
    ("Chilled water temperatures", "°C", "lin", [
        ("pla.bus.chi[1].TChiWatSet", "chi[1].TChiWatSet"),
        ("pla.bus.TChiWatPriSup", "TChiWatPriSup"),
        ("pla.bus.TChiWatEcoBef", "TChiWatEcoBef"),
        ("pla.bus.TChiWatEcoAft", "TChiWatEcoAft"),
        ("pla.bus.TChiWatPlaRet", "TChiWatPlaRet"),
    ], -K, 1),
    ("Condenser water temperatures", "°C", "lin", [
        ("pla.ctl.ctl.towCon.TConWatRetSet", "TConWatRetSet"),
        ("pla.bus.TConWatRet", "TConWatRet"),
        ("pla.bus.TConWatSup", "TConWatSup"),
    ], -K, 1),
    ("Cooling tower enable", "", "bin", [
        ("pla.bus.coo.y1[1]", "coo.y1[1]", "[1]"),
        ("pla.bus.coo.y1[2]", "coo.y1[2]", "[2]"),
    ], 0, 1),
    ("Cooling tower fan speed", "1", "lin", [
        ("pla.bus.coo.y", "coo.y"),
    ], 0, 1),
    ("Economizer CHW bypass valve", "1", "lin", [
        ("pla.bus.valChiWatEcoByp.y", "valChiWatEcoByp.y"),
        ("pla.eco.valChiWatByp.y_actual.y", "valChiWatByp.y_actual"),
    ], 0, 1),
    ("Minimum flow bypass valve", "1", "lin", [
        ("pla.bus.valChiWatMinByp.y", "valChiWatMinByp.y"),
        ("pla.bus.valChiWatMinByp.y_actual", "valChiWatMinByp.y_actual"),
    ], 0, 1),
]

# The .mos script plots the CW return temperature setpoint as
# pla.ctl.ctl.towCon.towFanSpe.fanSpeRetTem.conWatRetSet.TConWatRetSet, which no
# longer resolves; the signal is exposed one level up, on towCon itself.
RENAMED = [(
    "pla.ctl.ctl.towCon.towFanSpe.fanSpeRetTem.conWatRetSet.TConWatRetSet",
    "pla.ctl.ctl.towCon.TConWatRetSet",
)]

LIGHT = dict(
    surface="#fcfcfb", primary="#0b0b0b", secondary="#52514e", muted="#84837c",
    grid="#e8e7e2", zero="#d4d3cc",
    series=["#2a78d6", "#eb6834", "#1baf7a", "#eda100", "#e87ba4"],
)
DARK = dict(
    surface="#1a1a19", primary="#ffffff", secondary="#c3c2b7", muted="#8f8e85",
    grid="#2f2f2d", zero="#3d3d3a",
    series=["#3987e5", "#d95926", "#199e70", "#c98500", "#d55181"],
)


def read(path):
    """Return a lazily-caching accessor over one result file."""
    r = Reader(path, "dymola")
    names = set(r.varNames())
    cache = {}

    def get(name):
        if name not in cache:
            t, v = r.values(name)
            cache[name] = (list(t), list(v))
        return cache[name]

    return get, names


_RUNS = None


def runs():
    """The base run and every variant, keyed by name, each file read once."""
    global _RUNS
    if _RUNS is None:
        _RUNS = {RUN_A[0]: read(RUN_A[1])}
        _RUNS.update((name, read(path)) for name, path in RUNS_B.items())
    return _RUNS


_PANELS = None


def panels():
    """The panels whose signals every run records.

    A signal only some runs record is dropped rather than shown for some
    dropdown selections and not others.
    """
    global _PANELS
    if _PANELS is None:
        rec = [names for _, names in runs().values()]
        _PANELS = [
            (title, unit, kind, keep, off, sca)
            for title, unit, kind, sigs, off, sca in PANELS
            for keep in [[s for s in sigs if all(s[0] in n for n in rec)]]
            if keep
        ]
    return _PANELS


def absent():
    """Signals of PANELS that at least one run does not record."""
    rec = [names for _, names in runs().values()]
    return [s[0] for _, _, _, sigs, _, _ in PANELS for s in sigs
            if not all(s[0] in n for n in rec)]


def visibility(selected):
    """For each variant, the visibility of every trace over `selected` panels.

    The base run always stays on and only the traces of the selected variant
    join it.  The order follows the traces `make_figure` adds, so switching
    variants is a restyle of the figure rather than a rebuild.
    """
    vis = {name: [] for name in RUNS_B}
    for i in selected:
        for _ in panels()[i][3]:
            for run in [RUN_A[0]] + list(RUNS_B):
                for name in vis:
                    vis[name].append(run in (RUN_A[0], name))
    return vis


ROW_PX = 210   # vertical budget per panel
MARG_T = 34
MARG_B = 56

# Time units the axis can be shown in, as seconds per unit, and the span and
# tick spacing of the axis in seconds.
TUNITS = {"s": 1, "h": 3600}
DEFAULT_TUNIT = "s"
SPAN = 24 * 3600
DTICK = 2 * 3600


def make_figure(selected, theme, variant=None, tunit=DEFAULT_TUNIT):
    """Build the figure over `selected` panel indices, in `theme` colors.

    Every run is drawn and only the base run and `variant` are left visible,
    so the dropdown of the page switches variants by restyling the traces the
    figure already holds.  Time is shown in `tunit`, a key of TUNITS.
    """
    data = runs()
    variant = variant if variant in RUNS_B else DEFAULT_B
    per = TUNITS[tunit]
    selected = list(selected)
    chosen = [panels()[i] for i in selected]
    n = max(len(chosen), 1)
    visible = visibility(selected)

    fig = make_subplots(
        rows=n, cols=1, shared_xaxes=True,
        vertical_spacing=min(0.012 * 16 / n, 0.5),
        subplot_titles=[p[0] for p in chosen] or [""],
    )

    for row, (title, unit, kind, sigs, off, sca) in enumerate(chosen, start=1):
        lane = len(sigs) - 1
        for slot, sig in enumerate(sigs):
            var, label = sig[0], sig[1]
            for run, dash in [(RUN_A[0], "solid")] + [(b, "dot") for b in RUNS_B]:
                t, v = data[run][0](var)
                if kind == "bin":
                    y, cd, hov = ([lane - slot + 0.78 * x for x in v], v,
                                  "%{customdata:.0f}")
                else:
                    y, cd, hov = ([(x + off) * sca for x in v], None,
                                  "%{y:.4g}")
                fig.add_trace(
                    go.Scatter(
                        x=[x / per for x in t], y=y, customdata=cd,
                        name=f"{label} · {run}", meta=run,
                        legend=f"legend{row if row > 1 else ''}",
                        mode="lines", visible=run in (RUN_A[0], variant),
                        line=dict(
                            color=theme["series"][slot % 5], width=1.9, dash=dash,
                            shape="hv" if kind in ("stp", "bin") else "linear",
                        ),
                        hovertemplate=f"<b>{label}</b> · {run}<br>{hov} {unit}"
                                      "<extra></extra>",
                    ),
                    row=row, col=1,
                )
        if kind == "bin":
            fig.update_yaxes(
                row=row, col=1, range=[-0.35, len(sigs) - 0.1],
                tickmode="array", tickvals=list(range(len(sigs))),
                ticktext=[(s[2] if len(s) > 2 else s[1]) for s in reversed(sigs)],
                zeroline=False,
            )
        else:
            fig.update_yaxes(row=row, col=1, title_text=unit, title_standoff=4)
        # Keep a panel's own zoom when other panels are folded in or out.
        fig.update_yaxes(row=row, col=1, uirevision=title)

    fig.update_layout(
        height=MARG_T + MARG_B + ROW_PX * n, width=None,
        margin=dict(l=70, r=270, t=MARG_T, b=MARG_B),
        hovermode="x", showlegend=True,
        paper_bgcolor=theme["surface"], plot_bgcolor=theme["surface"],
        font=dict(color=theme["secondary"]),
    )
    fig.update_xaxes(
        showspikes=True, spikemode="across", spikesnap="cursor",
        spikethickness=1, spikedash="solid", spikecolor=theme["muted"],
        # A zoom is kept per unit, as a range in one unit is wrong in another.
        dtick=DTICK / per, range=[0, SPAN / per], uirevision=f"time {tunit}",
        gridcolor=theme["grid"], linecolor=theme["grid"],
        zerolinecolor=theme["zero"], tickcolor=theme["grid"],
    )
    fig.update_yaxes(
        gridcolor=theme["grid"], linecolor=theme["grid"],
        zerolinecolor=theme["zero"], tickcolor=theme["grid"],
    )
    if chosen:
        fig.update_xaxes(row=n, col=1, title_text=f"time ({tunit})")

    # One legend per panel, parked in the right margin beside its own panel.
    for row in range(1, len(chosen) + 1):
        dom = fig.get_subplot(row, 1).yaxis.domain
        fig.update_layout({f"legend{row if row > 1 else ''}": dict(
            x=1.005, xanchor="left", y=dom[1], yanchor="top",
            font=dict(size=10.5, color=theme["secondary"]),
            bgcolor="rgba(0,0,0,0)", borderwidth=0,
            tracegroupgap=0, itemsizing="constant",
        )})
    for ann in fig.layout.annotations:
        ann.update(font=dict(size=13, color=theme["primary"]),
                   x=0, xanchor="left")

    return fig


CSS = """
:root { color-scheme: dark; --surface:%(ds)s; --ink:%(dp)s; --ink2:%(dse)s;
        --ink3:%(dm)s; --rule:%(dg)s; }
body[data-theme="light"] { color-scheme: light; --surface:%(ls)s; --ink:%(lp)s;
        --ink2:%(lse)s; --ink3:%(lm)s; --rule:%(lg)s; }
html, body { margin:0; background:var(--surface); color:var(--ink);
  font:14px/1.5 ui-sans-serif,-apple-system,"Segoe UI",Roboto,sans-serif; }
header { display:flex; align-items:baseline; gap:16px; flex-wrap:wrap;
  padding:14px 20px 10px; border-bottom:1px solid var(--rule); }
header .note { color:var(--ink3); font-size:12.5px; }
header .pick { display:flex; align-items:center; gap:8px; }
#variant { width:132px; font-size:12.5px; }
#variant .Select-control, #variant .Select-menu-outer {
  background:var(--surface); border-color:var(--rule); color:var(--ink); }
#variant .Select-control { height:28px; }
#variant .Select-value, #variant .Select-placeholder { line-height:26px; }
#variant .Select-value-label, #variant .Select-option { color:var(--ink); }
#variant .Select-option { background:var(--surface); }
#variant .Select-option.is-focused, #variant .Select-option.is-selected {
  background:var(--rule); color:var(--ink); }
#variant.is-focused:not(.is-open) > .Select-control {
  border-color:var(--ink3); box-shadow:none; }
#variant .Select-arrow { border-top-color:var(--ink3); }
select { font:inherit; font-size:12.5px; color:var(--ink); background:var(--surface);
  border:1px solid var(--rule); border-radius:6px; padding:3px 8px; cursor:pointer; }
#bar { display:flex; align-items:center; gap:8px; flex-wrap:wrap;
  padding:10px 20px; border-bottom:1px solid var(--rule); }
#bar .lab { color:var(--ink3); font-size:12.5px; }
#bar .sep { width:1px; align-self:stretch; background:var(--rule); margin:0 4px; }
button { font:inherit; font-size:12.5px; color:var(--ink2); background:transparent;
  border:1px solid var(--rule); border-radius:6px; padding:4px 10px; cursor:pointer; }
button:hover { color:var(--ink); }
#chips label { display:inline-block; font-size:12.5px; color:var(--ink3);
  border:1px solid var(--rule); border-radius:6px; padding:3px 9px;
  margin:0 6px 6px 0; cursor:pointer; opacity:.6; }
#chips label:has(input:checked) { color:var(--ink); border-color:var(--ink3); opacity:1; }
#chips input { position:absolute; opacity:0; width:0; height:0; }
.unit { display:flex; }
.unit label { display:inline-block; font-size:12.5px; color:var(--ink3);
  border:1px solid var(--rule); padding:3px 10px; margin-left:-1px; cursor:pointer; }
.unit label:first-child { border-radius:6px 0 0 6px; margin-left:0; }
.unit label:last-child { border-radius:0 6px 6px 0; }
.unit label:has(input:checked) { color:var(--ink); border-color:var(--ink3);
  position:relative; }
.unit input { position:absolute; opacity:0; width:0; height:0; }
#absent { padding:10px 20px 24px; color:var(--ink3); font-size:12.5px; }
code { font-size:12px; }
"""

STYLE = CSS % dict(ds=DARK["surface"], dp=DARK["primary"], dse=DARK["secondary"],
                   dm=DARK["muted"], dg=DARK["grid"],
                   ls=LIGHT["surface"], lp=LIGHT["primary"],
                   lse=LIGHT["secondary"], lm=LIGHT["muted"], lg=LIGHT["grid"])

INDEX = """<!DOCTYPE html>
<html>
<head>{%%metas%%}<title>{%%title%%}</title>{%%favicon%%}{%%css%%}
<style>%s</style></head>
<body data-theme="light">{%%app_entry%%}<footer>{%%config%%}{%%scripts%%}
{%%renderer%%}</footer></body>
</html>
""" % STYLE

# The static page: the header and panel chips of the Dash app, done in the
# browser since there is no server to call back.  Each panel is a figure of
# its own, so folding a panel only hides its figure; the time axes, which the
# app gets from shared subplots, are kept in step by hand.  Only the dark
# theme is left to the app.
PAGE = """<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>%(title)s</title>
<style>%(css)s</style></head>
<body data-theme="light">
<header>
<div><b>Base</b><span class="note"> %(base)s — solid</span></div>
<div class="pick"><b>Variant</b>
<select id="variant">%(options)s</select>
<span class="note">— dotted</span></div>
<div class="pick"><b>Time</b><div class="unit">%(tunits)s</div></div>
</header>
<div id="bar"><span class="lab">Panels</span>
<div id="chips">%(chips)s</div>
<span class="sep"></span>
<button id="all-btn">All</button><button id="none-btn">None</button>
</div>
%(charts)s
<script>
const VIS = %(visible)s;
const panels = [...document.querySelectorAll(".panel")];
const plots = panels.map(p => p.querySelector(".plotly-graph-div"));
const boxes = [...document.querySelectorAll("#chips input")];
const sel = document.getElementById("variant");

// Variant: flip trace visibility in every panel, folded ones included.
sel.addEventListener("change", () =>
  plots.forEach((gd, i) => Plotly.restyle(gd, {visible: VIS[sel.value][i]})));

// Time unit: rescale the time of every trace, and the range and ticks of the
// time axis, so a zoom is kept across units.
const PER = %(tunit_per)s;
let unit = %(tunit)s;
document.querySelectorAll(".unit input").forEach(r => r.addEventListener(
  "change", () => {
    const f = PER[unit] / PER[r.value];
    unit = r.value;
    plots.forEach(gd => {
      const ax = gd.layout.xaxis;
      Plotly.update(gd, {x: gd.data.map(t => Array.from(t.x, v => v * f))}, {
        "xaxis.range": ax.range.map(v => v * f), "xaxis.dtick": ax.dtick * f,
        "xaxis.title.text": `time (${unit})`});
    });
  }));

// Panels: hide the figure of an unchecked chip.  A figure shown again is
// resized, as the page may have changed width while it was hidden.
function fold() {
  boxes.forEach((b, i) => {
    const was = panels[i].style.display !== "none";
    panels[i].style.display = b.checked ? "" : "none";
    if (b.checked && !was) Plotly.Plots.resize(plots[i]);
  });
}
boxes.forEach(b => b.addEventListener("change", fold));
document.getElementById("all-btn").onclick = () => {
  boxes.forEach(b => b.checked = true); fold(); };
document.getElementById("none-btn").onclick = () => {
  boxes.forEach(b => b.checked = false); fold(); };

// Time axis: zooming or panning one panel applies to all of them.  The
// relayout this sends to the other panels echoes back the same range, which
// is dropped.
let last = null;
plots.forEach(gd => gd.on("plotly_relayout", ev => {
  let upd;
  if ("xaxis.range[0]" in ev)
    upd = {"xaxis.range": [ev["xaxis.range[0]"], ev["xaxis.range[1]"]]};
  else if ("xaxis.range" in ev) upd = {"xaxis.range": ev["xaxis.range"]};
  else if (ev["xaxis.autorange"]) upd = {"xaxis.autorange": true};
  else return;
  const key = JSON.stringify(upd);
  if (key === last) return;
  last = key;
  plots.forEach(o => { if (o !== gd) Plotly.relayout(o, upd); });
}));
</script>
</body>
</html>
"""


def write_html(path):
    """Write every panel of every run to `path`, as one self-contained page.

    Return the number of traces written.
    """
    figs = [make_figure([i], LIGHT) for i in range(len(panels()))]
    opts = "".join(f'<option{" selected" if name == DEFAULT_B else ""}>{name}'
                   "</option>" for name in RUNS_B)
    chips = "".join(f'<label><input type="checkbox" checked>{escape(p[0])}'
                    "</label>" for p in panels())
    tunits = "".join(
        f'<label><input type="radio" name="tunit" value="{u}"'
        f'{" checked" if u == DEFAULT_TUNIT else ""}>{u}</label>'
        for u in TUNITS)
    charts = "\n".join(
        '<div class="panel">%s</div>' % fig.to_html(
            full_html=False, include_plotlyjs="cdn" if i == 0 else False,
            div_id=f"p{i}", config={"displaylogo": False, "responsive": True})
        for i, fig in enumerate(figs))
    # VIS[variant][panel]: the visibility of the traces of one panel.
    visible = {name: [visibility([i])[name] for i in range(len(figs))]
               for name in RUNS_B}
    with open(path, "w") as out:
        out.write(PAGE % dict(
            title=f"{RUN_A[0]} vs variants", css=STYLE, base=RUN_A[1],
            options=opts, chips=chips, charts=charts, tunits=tunits,
            visible=json.dumps(visible), tunit_per=json.dumps(TUNITS),
            tunit=json.dumps(DEFAULT_TUNIT),
        ))
    return sum(len(fig.data) for fig in figs)


def build_app():
    from dash import Dash, Input, Output, State, dcc, html

    titles = [p[0] for p in panels()]
    gone = absent()
    app = Dash(__name__, title=f"{RUN_A[0]} vs variants")
    app.index_string = INDEX

    app.layout = html.Div([
        html.Header([
            html.Div([html.B(RUN_A[0]),
                      html.Span(f" {RUN_A[1]} — solid", className="note")]),
            html.Div([
                html.B("Variants"),
                dcc.Dropdown(id="variant", clearable=False, searchable=False,
                             options=list(RUNS_B), value=DEFAULT_B),
                html.Span("— dotted", className="note"),
            ], className="pick"),
            html.Div([
                html.B("Time"),
                dcc.RadioItems(id="tunit", options=list(TUNITS),
                               value=DEFAULT_TUNIT, inline=True,
                               className="unit"),
            ], className="pick"),
            html.Button("Dark mode", id="theme-btn"),
        ]),
        html.Div([
            html.Span("Panels", className="lab"),
            dcc.Checklist(
                id="chips", options=[{"label": t, "value": i}
                                     for i, t in enumerate(titles)],
                value=list(range(len(titles))), inline=True,
            ),
            html.Span(className="sep"),
            html.Button("All", id="all-btn"),
            html.Button("None", id="none-btn"),
        ], id="bar"),
        dcc.Graph(id="chart", config={
            "displaylogo": False, "responsive": True,
            "toImageButtonOptions": {"format": "png", "scale": 2,
                                     "filename": f"{RUN_A[0]}_vs_variant"},
        }),
        html.Details([
            html.Summary("Signals dropped because at least one run does not "
                         "record them"),
            html.P("A variant needs not share the whole chiller interface with "
                   "the base model — HardCase1Compliance sets "
                   "intChi.use_cpl = true — and the configuration options of "
                   "the base model also decide which valves and sensors exist "
                   "at all:"),
            html.P([html.Code(", ".join(gone) or "none")]),
            html.P("The .mos script also plots one signal under a path that no "
                   "longer resolves; it is read here under its current name:"),
            html.P([html.Code(" → ".join(RENAMED[0]))]),
        ], id="absent"),
        dcc.Store(id="theme", data="light"),
        dcc.Store(id="fig"),
    ])

    @app.callback(Output("chips", "value"),
                  Input("all-btn", "n_clicks"), Input("none-btn", "n_clicks"),
                  prevent_initial_call=True)
    def _select(_all, _none):
        from dash import ctx
        return list(range(len(titles))) if ctx.triggered_id == "all-btn" else []

    @app.callback(Output("theme", "data"), Output("theme-btn", "children"),
                  Input("theme-btn", "n_clicks"), State("theme", "data"),
                  prevent_initial_call=True)
    def _theme(_n, cur):
        nxt = "light" if cur == "dark" else "dark"
        return nxt, ("Dark mode" if nxt == "light" else "Light mode")

    app.clientside_callback(
        "function(t) { document.body.dataset.theme = t; return window.dash_clientside.no_update; }",
        Output("theme", "id"), Input("theme", "data"))

    @app.callback(Output("fig", "data"),
                  Input("chips", "value"), Input("theme", "data"),
                  Input("tunit", "value"))
    def _figure(selected, theme, tunit):
        return make_figure(sorted(selected or []),
                           LIGHT if theme == "light" else DARK, tunit=tunit)

    # The browser already holds every variant, so switching one in only
    # flips the visibility flags instead of sending the traces again.  The
    # flags are set from the figure and the variant as they both stand now,
    # so a variant picked while a figure is still on its way is not lost when
    # the figure arrives.
    app.clientside_callback(
        """function(fig, variant) {
            if (!fig) return window.dash_clientside.no_update;
            return {...fig, data: fig.data.map(t => ({...t,
                visible: t.meta === %s || t.meta === variant}))};
        }""" % json.dumps(RUN_A[0]),
        Output("chart", "figure"), Input("fig", "data"),
        Input("variant", "value"))

    return app


if __name__ == "__main__":
    if "--html" in sys.argv:
        print(f"{OUT}: {len(panels())} panels, {write_html(OUT)} traces, "
              f"{len(RUNS_B)} variants")
        if absent():
            print("dropped: " + ", ".join(absent()))
    else:
        print(f"{len(panels())} panels — http://127.0.0.1:{PORT}")
        build_app().run(debug=False, port=PORT)
