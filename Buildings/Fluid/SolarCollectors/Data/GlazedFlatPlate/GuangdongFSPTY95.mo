within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record GuangdongFSPTY95 =
    SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Gross,
    A=2,
    mDry=35,
    V=1.7/1000,
    dp_nominal=8719,
    mperA_flow_nominal=0.02,
    B0=-0.2165,
    B1=0.023,
    y_intercept=0.678,
    slope=-4.426,
    IAMDiff=0,
    C1=0,
    C2=0,
    G_nominal = 1000,
    dT_nominal = 10) "Guandong Fivestar Solar Energy Co, FS-PTY95-2.0"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    <p>
    Ratings data taken from the <a href=\"http://www.solar-rating.org\">
    Solar Rating and Certification Corporation website</a>. SRCC# = 2012043A.<br/>
    </p>
    </html>"));
