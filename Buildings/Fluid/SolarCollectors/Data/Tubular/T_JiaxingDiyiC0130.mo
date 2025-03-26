within Buildings.Fluid.SolarCollectors.Data.Tubular;
record T_JiaxingDiyiC0130 =
    Buildings.Fluid.SolarCollectors.Data.GenericASHRAE93 (
    final A=4.650,
    final CTyp=Buildings.Fluid.SolarCollectors.Types.HeatCapacity.DryMass,
    final C=0,
    final mDry=95,
    final V=1.7/1000,
    final dp_nominal=100,
    final mperA_flow_nominal=0.0142,
    final incAngDat=Modelica.Units.Conversions.from_deg({0,10,20,30,40,50,60,70,80,90}),
    final incAngModDat={1.0,1.0222,1.0897,1.2034,1.3596,1.5272,1.5428,0.4206,0.0,0.0},
    final y_intercept=0.388,
    final slope=-1.453) "T - Jiaxing Diyi New Energy Co., Ltd., DIYI-C01-30"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info = "<html>
<h4>References</h4>
<p>
Ratings data taken from the <a href=\"http://www.solar-rating.org\">
Solar Rating and Certification Corporation website</a>.
SRCC# = 2012036A.
</p>
<p>
The ratings provided for <code>dp_nominal</code> were suspicious
so 100 Pa is used instead.<br/>
</p>
</html>"));
