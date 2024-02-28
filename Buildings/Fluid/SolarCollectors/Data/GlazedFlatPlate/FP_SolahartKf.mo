within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record FP_SolahartKf =
    Buildings.Fluid.SolarCollectors.Data.GenericASHRAE93 (
    final A=2.003,
    final CTyp=Buildings.Fluid.SolarCollectors.Types.HeatCapacity.DryMass,
    final C=0,
    final mDry=42,
    final V=3.8/1000,
    final dp_nominal=93.89,
    final mperA_flow_nominal=0.0194,
    final incAngDatDeg={0,10,20,30,40,50,60,70,80,90},
    final incAngModDat={1.0,0.9979,0.9913,0.9792,0.9597,0.929,0.8796,0.7979,0.724,0.0},
    final y_intercept=0.775,
    final slope=-5.103) "FP - Solahart Kf"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info = "<html>
<h4>References</h4>
<p>
Ratings data taken from the <a href=\"http://www.solar-rating.org\">
Solar Rating and Certification Corporation website</a>. SRCC# = 2012021A.<br/>
</p>
</html>"));
