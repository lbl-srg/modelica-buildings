within Buildings.Fluid.SolarCollectors.Data.Concentrating;
record CogenraSunDeck =
  SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Aperture,
    A=4.302,
    V=4.4/1000,
    mperA_flow_nominal=0.0241,
    y_intercept=0.720,
    IAMDiff=0.133,
    C1=2.8312,
    C2=0.00119,
    B0=0,
    B1=0,
    mDry=484,
    slope=0) "Cogenra Solar, Inc., SunDeck 1.0"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2011127A.<br>
    </p>
    <p>
    Necessary data for calculating dP_nominal, G_nominal and dT_nominal is not provided in the EN12975 test data. All are left blank.
    <p>
    </html>"));
