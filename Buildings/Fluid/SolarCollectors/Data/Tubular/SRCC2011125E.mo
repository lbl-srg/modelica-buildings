within Buildings.Fluid.SolarCollectors.Data.Tubular;
record SRCC2011125E =
    SolarCollectors.Data.Tubular.Generic (
    ATyp=Types.Area.Gross,
    Fluid=Types.DesignFluid.Water,
    A=3.860,
    mDry=77,
    V=2.6/1000,
    dp_nominal=900*1000,
    VperA_flow_nominal=8.4/(10^6),
    B0=0.1405,
    B1=-0.0298,
    y_intercept=0.624,
    slope=-0.975,
    IAMDiff=0,
    C1=0,
    C2=0) "Kloben Sud S.r.l., Solar Collectors Sky Pro 1800, Sky Pro 18 CPC 58"
    annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2011125E.<br>
    </p>
    </html>"));
