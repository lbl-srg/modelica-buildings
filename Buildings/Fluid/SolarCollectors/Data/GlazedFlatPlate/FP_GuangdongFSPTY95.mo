within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record FP_GuangdongFSPTY95 =
    Buildings.Fluid.SolarCollectors.Data.GenericASHRAE93 (
    final A=2,
    final mDry=35,
    final CTyp=Buildings.Fluid.SolarCollectors.Types.HeatCapacity.DryMass,
    final C=0,
    final V=1.7/1000,
    final dp_nominal=235,
    final mperA_flow_nominal=0.02,
    final incAngDatDeg={0,10,20,30,40,50,60,70,80,90},
    final incAngModDat={1.0,0.9967,0.9862,0.9671,0.9360,0.8868,0.8065,0.6686,0.4906,0.0},
    final y_intercept=0.678,
    final slope=-4.426)
  "FP - Guandong Fivestar Solar Energy Co, FS-PTY95-2.0"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info = "<html>
<h4>References</h4>
<p>
Ratings data taken from the <a href=\"http://www.solar-rating.org\">
Solar Rating and Certification Corporation website</a>. SRCC# = 2012043A.<br/>
</p>
</html>"));
