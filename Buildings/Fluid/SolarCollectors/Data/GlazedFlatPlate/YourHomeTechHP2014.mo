within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record YourHomeTechHP2014 =
    SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Gross,
    A=2.859,
    mDry=53,
    V=3.9/1000,
    dp_nominal=13.26,
    mperA_flow_nominal=0.02,
    B0=-0.1711,
    B1=0.0082,
    y_intercept=0.671,
    slope=-5.236,
    IAMDiff=0,
    C1=0,
    C2=0,
    G_nominal = 1000,
    dT_nominal = 10) "Your Home Tech., Ltd., HP-2014"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    <p>
    Ratings data taken from the <a href=\"http://www.solar-rating.org\">
    Solar Rating Certification Corporation website</a>.
    SRCC# = 2012041A.
    </p>
    </html>"));
