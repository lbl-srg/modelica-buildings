within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record SRCC2001002B =
    SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Gross,
    A=0.933,
    mDry=8.6,
    V=0.6/1000,
    dp_nominal=1103*1000,
    mperA_flow_nominal=0.0169,
    B0=-0.194,
    B1=-0.019,
    y_intercept=0.602,
    slope=-3.764,
    IAMDiff=0,
    C1=0,
    C2=0) "Water-based, ACR Solar International: Skyline 10-01"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2001002B.<br>
    </p>
    </html>"));
