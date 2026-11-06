within Buildings.Controls.OBC.DemandFlexibility;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
annotation (preferredView="info",
Documentation(info="<html>
<p>
The <code>DemandFlexibility</code> sequence package follows the folder structure
below:
</p>
<pre>
DemandFlexibility
├── Generic
│   ├── Block1.mo
│   ├── Block2.mo
│   └── Validation
│       ├── Block1.mo
│       └── Block2.mo
├── Strategy1
│   ├── Controller.mo
│   ├── Subsequences
│   │   ├── Adjustment.mo
│   │   ├── LowerUpperBound.mo
│   │   ├── Prioritization.mo
│   │   ├── Qualification.mo
│   │   └── Validation
│   │       ├── Adjustment.mo
│   │       ├── LowerUpperBound.mo
│   │       ├── Prioritization.mo
│   │       └── Qualification.mo
│   └── Validation
│       └── Controller.mo
├── Strategy2
│   ├── Controller.mo
│   ├── Subsequences
│   │   ├── Adjustment.mo
│   │   ├── LowerUpperBound.mo
│   │   ├── Prioritization.mo
│   │   ├── Qualification.mo
│   │   └── Validation
│   │       ├── Adjustment.mo
│   │       ├── LowerUpperBound.mo
│   │       ├── Prioritization.mo
│   │       └── Qualification.mo
│   └── Validation
│       └── Controller.mo
└── Types
    ├── ModeEnumeration1.mo
    └── ModeEnumeration2.mo
</pre>
<p>
This folder structure has the following properties:
</p>
<ul>
<li>
The <code>DemandFlexibility</code> sequence package can contain multiple demand
flexibility strategies.
</li>
<li>
The <code>Generic</code> folder contains blocks that are used by multiple demand
flexibility strategies.
</li>
<li>
For each demand flexibility strategy, the <code>Controller.mo</code> block is the
overarching logic block for that demand flexibility strategy.
</li>
<li>
The <code>Subsequences</code> folder contains lower-level logic blocks that are
used by the main <code>Controller.mo</code> block. These lower-level logic blocks
can include <code>Adjustment.mo</code>, <code>LowerUpperBound.mo</code>,
<code>Prioritization.mo</code>, and <code>Qualification.mo</code>.
</li>
<li>
The <code>Qualification.mo</code> block specifies whether a zone or a piece of
equipment is qualified to participate in a demand flexibility strategy based on
fault detection rules.
</li>
<li>
The <code>Prioritization.mo</code> block ranks the setpoints or the limiting values
from all zones or all pieces of equipment and decides which zones or pieces of
equipment are prioritized to provide demand flexibility.
</li>
<li>
The <code>Adjustment.mo</code> block executes the changes of setpoints or limiting
values from qualified and prioritized zones or pieces of equipment.
</li>
<li>
The <code>LowerUpperBound.mo</code> block specifies whether the setpoint or the
limiting value from a zone or a piece of equipment has reached a lower bound or an
upper bound. If so, these zones or pieces of equipment are removed from the
prioritization step and the adjustment step even though they are qualified zones or
pieces of equipment.
</li>
<li>
The <code>Types</code> folder contains enumerations of modes that are used by
multiple demand flexibility strategies.
</li>
</ul>
</html>
"));
end UsersGuide;
