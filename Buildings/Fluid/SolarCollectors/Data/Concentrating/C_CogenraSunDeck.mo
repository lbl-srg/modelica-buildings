within Buildings.Fluid.SolarCollectors.Data.Concentrating;
record C_CogenraSunDeck =
  Buildings.Fluid.SolarCollectors.Data.GenericEN12975 (
    final ATyp=Types.Area.Aperture,
    final A=4.302,
    final V=4.4/1000,
    final mperA_flow_nominal=0.0241,
    final eta_0=0.720,
    final IAMDiff=0.133,
    final C1=2.8312,
    final C2=0.00119,
    final B0=0,
    final B1=0,
    final mDry=484,
    final slope=0) "C - Cogenra Solar, Inc., SunDeck 1.0"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info = "<html>
      <p>
        Necessary data for calculating <code>dp_nominal</code>, <code>G_nominal
        </code> and <code>dT_nominal</code> is not provided in the EN12975 test
        data. All are left blank.
      </p>
    <h4>References</h4>
      <p>
        Ratings data taken from the <a href=\"http://www.solar-rating.org\">
        Solar Rating and Certification Corporation website</a>. SRCC# = 2011127A.<br/>
      </p>
    </html>"));
