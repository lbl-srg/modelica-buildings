within Buildings.Fluid.SolarCollectors.Data.Tubular;
record SRCC2011125E =
    SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Gross,
    A=3.860,
    mDry=77,
    V=2.6/1000,
    dp_nominal=900*1000,
    mperA_flow_nominal=0.0084,
    B0=0.1405,
    B1=-0.0298,
    y_intercept=0.624,
    slope=-0.975,
    IAMDiff=0,
    C1=0,
    C2=0) "Kloben Sud S.r.l., Solar Collectors Sky Pro 1800, Sky Pro 18 CPC 58"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2011125E.<br>
    </p>
    </html>"));
