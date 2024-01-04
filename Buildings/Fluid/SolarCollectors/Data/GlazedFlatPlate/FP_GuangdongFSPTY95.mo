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
    final b0=-0.2165,
    final b1=0.023,
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
