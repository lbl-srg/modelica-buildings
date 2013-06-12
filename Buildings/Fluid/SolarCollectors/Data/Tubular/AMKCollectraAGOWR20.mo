within Buildings.Fluid.SolarCollectors.Data.Tubular;
record AMKCollectraAGOWR20 =
    SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Gross,
    A=3.457,
    mDry=73,
    V=3.5/1000,
    dp_nominal=2.02,
    mperA_flow_nominal=0.0201,
    B0=0.5722,
    B1=-0.0052,
    y_intercept=0.446,
    slope=-1.432,
    IAMDiff=0,
    C1=0,
    C2=0,
    G_nominal = 1000,
    dT_nominal = 10) "AMG Collectra AG, OWR 20"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    <p>
    Ratings data taken from the <a href=\"http://www.solar-rating.org\">Solar Rating Certification Corporation website</a>.
    SRCC# = 2012018A.<br/>
    </p>
    </html>"));
