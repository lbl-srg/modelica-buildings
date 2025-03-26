within Buildings.Fluid.SolarCollectors.Data.Tubular;
record T_AMKCollectraAGOWR20 =
    Buildings.Fluid.SolarCollectors.Data.GenericASHRAE93 (
    final A=3.457,
    final CTyp=Buildings.Fluid.SolarCollectors.Types.HeatCapacity.DryMass,
    final C=0,
    final mDry=73,
    final V=3.5/1000,
    final dp_nominal=100,
    final mperA_flow_nominal=0.0201,
    final incAngDat=Modelica.Units.Conversions.from_deg({0,10,20,30,40,50,60,70,80,90}),
    final incAngModDat={1.0,1.0088,1.0367,1.0884,1.1743,1.3164,1.567,2.0816,3.6052,0.0},
    final y_intercept=0.446,
    final slope=-1.432) "T - AMG Collectra AG, OWR 20"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info = "<html>
<h4>References</h4>
<p>
Ratings data taken from the <a href=\"http://www.solar-rating.org\">
Solar Rating and Certification Corporation website</a>.
SRCC# = 2012018A.
</p>
<p>
The ratings provided for <code>dp_nominal</code> were suspicious
so 100 Pa is used instead.<br/>
</p>
</html>"));
