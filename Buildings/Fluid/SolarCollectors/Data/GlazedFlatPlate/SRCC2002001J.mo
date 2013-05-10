within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record SRCC2002001J =
    SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Gross,
    A=1.438,
    mDry=26.76,
    V=2.6/1000,
    dp_nominal=1103*1000,
    mperA_flow_nominal=0.0201,
    B0=-0.1958,
    B1=-0.0036,
    y_intercept=0.703,
    slope=-4.902,
    IAMDiff=0,
    C1=0,
    C2=0) "Alternate Energy, AE-16"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2002001J.<br>
    </p>
    </html>"));
