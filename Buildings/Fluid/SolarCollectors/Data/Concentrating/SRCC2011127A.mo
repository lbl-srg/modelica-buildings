within Buildings.Fluid.SolarCollectors.Data.Concentrating;
record SRCC2011127A =
  SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Aperture,
    A=3.364,
    dp_nominal=1069*1000,
    V=4.4/1000,
    mperA_flow_nominal=0.0241,
    y_intercept=0.720,
    IAMDiff=0.133,
    C1=2.8312,
    C2=0.00119,
    B0=0,
    B1=0,
    mDry=484,
    slope=0) "Cogenra Solar, SunDeck"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2011127A.<br/>
    </html>"));
