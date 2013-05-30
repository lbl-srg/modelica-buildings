within Buildings.Fluid.SolarCollectors.Data.Tubular;
record SRCC2011133G =
    SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Gross,
    A=3.624,
    mDry=68,
    V=2.6/1000,
    dp_nominal=900*1000,
    mperA_flow_nominal=0.0179,
    B0=0.125,
    B1=-0.0163,
    y_intercept=0.609,
    slope=-1.051,
    IAMDiff=0,
    C1=0,
    C2=0) "Evosolar, EVOT-21"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2011133G.<br>
    </p>
    </html>"));
