within Buildings.Fluid.SolarCollectors.Data.Tubular;
record SRCC2012033A =
    SolarCollectors.Data.GenericSolarCollector (
    ATyp=Types.Area.Gross,
    A=4.673,
    mDry=111,
    V=2.3/1000,
    dp_nominal=1*1000,
    mperA_flow_nominal=0.0201,
    B0=1.3766,
    B1=-0.9294,
    y_intercept=0.422,
    slope=-1.864,
    IAMDiff=0,
    C1=0,
    C2=0) "G.S. Inc., Suntask, SR30"
    annotation(Documentation(info = "<html>
    <h4>References</h4>
    <p>
    Ratings data taken from the Solar Rating Certification Corporation website. SRCC# = 2012033A.<br/>
    </p>
    </html>"));
