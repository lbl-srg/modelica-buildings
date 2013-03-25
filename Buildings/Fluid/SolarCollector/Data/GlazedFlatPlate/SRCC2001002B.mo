within Buildings.Fluid.SolarCollector.Data.GlazedFlatPlate;
record SRCC2001002B =
    Buildings.Fluid.SolarCollector.Data.GlazedFlatPlate.GenericGlazedFlatPlate
    (
    ATyp=Buildings.Fluid.SolarCollector.Types.Area.Gross,
    Fluid = Buildings.Fluid.SolarCollector.Types.DesignFluid.Water,
    A=0.933,
    mDry=8.6,
    V=0.6/1000,
    dp_nominal=1103*1000,
    VperA_flow_nominal=16.9/(10^6),
    B0=-0.194,
    B1=-0.019,
    y_intercept = 0.602,
    slope= - 3.764,
    IAMDiff = 0,
    C1 = 0,
    C2 = 0) "Water-based, ACR Solar International: Skyline 10-01"
    annotation(Documentation(info = "<html>
    <h4>Citation</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2001002B.<br>
    </p>
    </html>"));
