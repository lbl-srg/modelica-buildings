within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record FPYourHomeTechHP2014 =
    SolarCollectors.Data.GenericSolarCollector (
    final ATyp=Types.Area.Gross,
    final A=2.859,
    final mDry=53,
    final V=3.9/1000,
    final dp_nominal=13.26,
    final mperA_flow_nominal=0.02,
    final B0=-0.1711,
    final B1=0.0082,
    final y_intercept=0.671,
    final slope=-5.236,
    final IAMDiff=0,
    final C1=0,
    final C2=0,
    final G_nominal = 1000,
    final dT_nominal = 10) "FP - Your Home Tech., Ltd., HP-2014"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    <p>
    Ratings data taken from the <a href=\"http://www.solar-rating.org\">
    Solar Rating and Certification Corporation website</a>.
    SRCC# = 2012041A.
    </p>
    </html>"));
