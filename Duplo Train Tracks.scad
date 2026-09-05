/* [Generate object] */
/*





*/


// Generate: 1 Brick, 2 Plate, 3 BasePlate, 4 Calibration parts, 5 Track
GenerateObject=5;//[1:Brick,2:Plate,3:Base plate,4:Calibration parts,5:Track]
// Object knobs in X direction
GenerateKnobsX=2;//[1:20] 
// Object knobs in Y direction
GenerateKnobsY=4;//[1:20]

GenerateSecondCalibrationTrackEnd = 1; //[1:Yes,0:No]

/* [Basic brick dimensions + print corrections] */
// Unit size (or pitch)
Unit=16;           
// Diameter of knob on top of brick
KnobD=9.4;      
// Height of knob
KnobL=4.6;        
// Hollow knob on top?
geo_hollow_knop=1; //[1:Yes,0:No]
// Height of recess underside of brick (should always > KnobL)
StudH=5;          
// Size of knob hole underside of brick (interfaces with knob)
StudD=9.4;      
// Diameter of tube underside of brick (3 for 4x2brick)
TubeD=13.2;    
// Height of standard brick
BrickH=19.2;    
// Thickness of outside wall
BrickWallT=1.5;//1.6   
// Horizontal tolerance/play at one side of a wall
HorzPlay=0.1;  
// Height of plate (Duplo: 50%; Lego 33%)
PlateH=9.6; 
// Height of baseplate
BasePlateH=1.6;    

/* [Basic train track dimensions + print corrections] */
// Half sleeper diameter of connector pin (train track)
TrackPin=9.2;   
// Diameter of connector hole in half sleeper
TrackHole=9.9;   
// Witdh of the part connecting pin & half sleeper
TrackPinWidth=6.4; 
// Track width
TrackFullWidth = 54;
// Distance betweens wheels
TrackWheelWidth = 31.8; //Schräge fläche gegen mitte, grösser bei Brücke als bei Schiene 31.8

/* [Additional features] */
// Some ribs at bottom, so no support is needed
GeoUseRibs=0; //[1:Yes,0:No]

/* [Ribs] */
// Test mode: 1 = only rail + BigRibs
test_bigribs_only = 0; //[1:Yes,0:No]

// Big ribs
BigRibPitch = 3.16; //Distanz zwischen den Zähnen
BigRibBottomDepth = 2.0; //Zahnbreite unten Archiv 1.4
BigRibTopDepth = 1.0;//Zahnbreite oben 0.8
BigRibHeight = 2.8; //Zahn höhe Archiv:1.8 zu klein
BigRibWidth = 4.0; //"Länge" Archiv 3.2

// Small ribs
SmallRibPitch = 1;
SmallRibDepth = 0.5;
SmallRibHeight = 0.5;

// Rib base surface
RibBaseZ = 7.3;



// CUSTOM PARAMETERS ======================================================================
/* [Track] */
//Straight = 0 or Curved track (Standard curved track=30)
TrackAngle=0; // [-90:5:90]
//Length of track (studs)
TrackLengthStuds=8; // [2:16]
track_length = TrackLengthStuds * Unit;
//Radius of track (in case of curved track)
//track_radius=260;// Radius of curve (standard track curve R = 260 mm)
//How many sleepers are needed?
nr_of_sleepers = 1; // [0:5]
//Since old tracks (before 2003) use single sleepers:
use_full_sleepers=1; //[1:Yes,0:No]
/* [Ramp] */
//Add what height should the track end (bricks)?
ramp_height=0;// [0:10]
//Want to extend end of track, so a new track could be placed on this
ramp_extend_support=0; //[1:Yes,0:No]
/* [Geometry] */
//Rail offset from ground:
geo_use_offset=0; //[1:Yes,0:No]
//Use big ribs on side of track for climbing
geo_use_bigribs=0; //[1:Yes,0:No]
//Use small ribs:
geo_use_smallribs=1; //[1:Yes,0:No]
//Increase rim thickness for more robust track:
geo_rim_thickness_increase=0.6;// should be >=0.

//====================================================================================
// Generate top click interface:
module GenerateKnobs(unitsX=2,unitsY=4,unitsZ=1,angle_deg=0)
{
//Adding knobs:
    translate([0,0,unitsZ*BrickH]) rotate(angle_deg,[0,-1,0])
    {
        for(dy=[-(unitsY-.5)*Unit/2:Unit:(unitsY-.5)*Unit/2])
        {
            for(dx=[-(unitsX-.5)*Unit/2:Unit:(unitsX-.5)*Unit/2])
            { 
                translate([dx+0.25*Unit,dy+0.25*Unit,0]) difference()
                {
                    translate([0,0,-1])
                    {
                        cylinder(h=KnobL+0.5,d=KnobD,center=false);
                        translate([0,0,KnobL+0.5]) cylinder(h=0.5,d1=KnobD, d2=KnobD-1, center=false);
                    }
                
                    if (geo_hollow_knop)
                    {
                        translate([0,0,.5])
                        {
                            cylinder(h=KnobL,d=KnobD-2*BrickWallT,center=false);
                        }
                    }                
                }
            }
        }//End knobs.
    }
}

// Generate bottom click interface: height=StudH+1.
module GenerateStuds(unitsX=2,unitsY=4){
    translate([0,0,StudH/2])
    union() {
    difference() {
    union() {
        difference() { //Add recess frame:
            translate([0,0,0.5]) cube([unitsX*Unit-2*HorzPlay,unitsY*Unit-2*HorzPlay,StudH+1],true);
            cube([unitsX*Unit-2*BrickWallT,unitsY*Unit-2*BrickWallT,2*StudH],true);
        } //Add ribs:
            for(dy=[-(unitsY-.5)*Unit/2:Unit:(unitsY-1.5)*Unit/2]) {
                translate([0,dy+0.25*Unit,0]) cube([unitsX*Unit-4*HorzPlay,BrickWallT,StudH],true);
                }
            for(dx=[-(unitsX-.5)*Unit/2:Unit:(unitsX-1.5)*Unit/2]) { 
                translate([dx+0.25*Unit,0,0]) cube([BrickWallT,unitsY*Unit-4*HorzPlay,StudH],true);
            }
            
        } //Subtract inner section, getting short ribs
        cube([unitsX*Unit-(Unit-StudD),unitsY*Unit-(Unit-StudD),2*StudH],true);
        
    } //Add roof (1mm thick) & Tubes: & long ribs:
    difference() {
    union() {
    translate([0,0,StudH/2+.5]) { cube([unitsX*Unit-2*HorzPlay,unitsY*Unit-2*HorzPlay,1],true);}
    if ((unitsX>1)&&(unitsY>1)) {
        if (GeoUseRibs) { //add optioanl long ribs:
            for(dy=[-(unitsY-2)/2*Unit:Unit:(unitsY-2)/2*Unit]) {
                translate([0,dy,0.25]) cube([unitsX*Unit-4*HorzPlay,BrickWallT,5.5],true);}
            for(dx=[-(unitsX-2)/2*Unit:Unit:(unitsX-2)/2*Unit]) {
                translate([dx,0,0.25]) cube([BrickWallT,unitsY*Unit-4*HorzPlay,5.5],true);} }
            //Add tubes:
            for(dy=[-(unitsY-1.5)/2*Unit:Unit:(unitsY-1.5)/2*Unit]) {
                for(dx=[-(unitsX-1.5)/2*Unit:Unit:(unitsX-1.5)/2*Unit]) { 
            translate([dx+0.25*Unit,dy+0.25*Unit,0]) 
                cylinder($fn=16,h=StudH,d=TubeD,center=true); } } //End adding Tubes.  
    } } //Remove innerside of tubes:
        for(dy=[-(unitsY-1.5)/2*Unit:Unit:(unitsY-1.5)/2*Unit]) {
            for(dx=[-(unitsX-1.5)/2*Unit:Unit:(unitsX-1.5)/2*Unit]) { 
        translate([dx+0.25*Unit,dy+0.25*Unit,0]) 
            cylinder($fn=8,h=StudH+.1,d=TubeD-2*BrickWallT,center=true);   }}
            } //End subtract
    } //End union all
}

//Generate standard brick:
module GenerateBrick(unitsX=2,unitsY=4,unitsZ=1,angle_deg=0,hasKnobs=true,hasStuds=true) {
    union(){
        rotate(90,[1,0,0]) { //BASIC (ANGLED) BRICK BODY:
            H =(hasStuds) ? StudH : 0 ;
            p0=[(unitsX*Unit/2-HorzPlay), H ];
            p1=[p0[0], unitsZ*BrickH+tan(angle_deg)*(unitsX/2*Unit-HorzPlay)];
            p2=[-p0[0],unitsZ*BrickH-tan(angle_deg)*(unitsX/2*Unit-HorzPlay)];
            p3=[-p0[0],p0[1]];
            linear_extrude(height=unitsY*Unit-2*HorzPlay, center=true) polygon([p0,p1,p2,p3]); 
        }
        if (hasKnobs) {GenerateKnobs(unitsX,unitsY,unitsZ,angle_deg);}
        if (hasStuds) {GenerateStuds(unitsX,unitsY);}
    }
}

//Generate a plate:
module GeneratePlate(unitsX=4,unitsY=10) {
    GenerateBrick(unitsX,unitsY,0.5);
} 

//Generate a baseplate:
module GenerateBasePlate(unitsX=12,unitsY=12,Zmm=BasePlateH) {
    union() {
        linear_extrude(height = Zmm) { offset(r = Unit/4) {
        square([(unitsX-0.5)*Unit-2*HorzPlay,(unitsY-0.5)*Unit-2*HorzPlay], center = true); } }
        GenerateKnobs(unitsX,unitsY,Zmm/BrickH,0);
    }
}    


//Generate track end sleeper:
module GenerateTrainTrackEnd() {

    end_bridge_width =
        TrackWheelWidth - 2*(2.4 + geo_rim_thickness_increase);

    difference() {
        union() {

            translate([Unit/2,0,0])
                GenerateStuds(1,4);

            translate([Unit/2,0,7.5])
                cube([
                    Unit-2*HorzPlay,
                    end_bridge_width,
                    5
                ],center=true);

            translate([-Unit/4,-Unit/2,5])
                cube([Unit/2+1,TrackPinWidth,10],center=true);

            translate([-Unit/2,-Unit/2,5])
                cylinder(d=TrackPin,h=10,center=true);

            translate([Unit/4,Unit/2,2.5])
                cube([
                    Unit/2-1,
                    TrackPinWidth+2*BrickWallT,
                    5
                ],center=true);

            translate([Unit/2,Unit/2,2.5])
                cylinder(
                    d=TrackPin+2*BrickWallT,
                    h=5,
                    center=true
                );

            translate([Unit/2,Unit/2,2.5])
                cube([
                    BrickWallT,
                    2*Unit-StudD,
                    5
                ],center=true);
        }

        translate([Unit/4,Unit/2,5])
            cube([
                Unit/2+1,
                TrackPinWidth+.45,
                12
            ],center=true);

        translate([Unit/2,Unit/2,5])
            cylinder(d=TrackHole,h=12,center=true);

        translate([-Unit/4,-Unit/2,0])
            rotate([90,0,0])
                linear_extrude(height=10,$fn=3,center=true)
                    polygon(points=[
                        [-(Unit/2+0.5),-0.5],
                        [-(Unit/2+0.5),8],
                        [-(Unit/2+0.5)+TrackPin,4],
                        [Unit/4+0.1,0],
                        [Unit/4+0.1,-0.5]
                    ]);
    }
}



module CalibrationPieces(){
    //Write down the numbers from above & print these pieces:

    //Testing studs:
    //StudD=      //[mm] size of knob hole underside of brick (interfaces with knob)
    //StudH=      //[mm] height of recess underside of brick
    //TubeD=      //[mm] diameter of tube underside of brick (3 for 4x2brick)
    //BrickWallT= //[mm] Thickness of outside wall
    //HorzPlay=   //[mm] Horizontal tolerance/play at one side of a wall
    translate([0,0,StudH+1]) rotate(180,[1,0,0]) GenerateStuds(GenerateKnobsX,GenerateKnobsY);
    
    //Testing the knobs:
    //KnobD=      //[mm] diameter of knob on top
    //KnobL=      //[mm] height of knob
    //BasePlateH= //[mm] Height of plate (according thing:1356494)
    translate([GenerateKnobsX * Unit + 5,0,0]) GenerateBasePlate(GenerateKnobsX,GenerateKnobsY);
    
    translate([1.5*GenerateKnobsX * Unit + 1.5*Unit,0,0])
        GenerateTrainTrackEnd();
    if (GenerateSecondCalibrationTrackEnd)
        translate([1.5*GenerateKnobsX * Unit + 4*Unit,0,0]) rotate([0,0,180])
            GenerateTrainTrackEnd();
    }


// TESTING: ==========================================================================
//render()
{
if (GenerateObject==1) { GenerateBrick(GenerateKnobsX,GenerateKnobsY); }
if (GenerateObject==2) { GeneratePlate(GenerateKnobsX,GenerateKnobsY); }
if (GenerateObject==3) { GenerateBasePlate(GenerateKnobsX,GenerateKnobsY); }
if (GenerateObject==4) { CalibrationPieces(); }
if (GenerateObject==5) { GenerateTrack(); }
}

// Remarks:
// Don't make "bridges" to high:
// Close at the bottom, the top of train & wagon collide.
// At top, the carrier will tough the rim on the rail.


// CALCULATIONS =========================================================================
pi=3.141592;
track_radius = track_length/sin(abs(TrackAngle));
lengthxy = (TrackAngle==0) ? track_length : abs(TrackAngle/360)*pi*2*track_radius;
ramp_tilt_angle = atan(ramp_height*BrickH/lengthxy);
geo_rail_zoffset= (geo_use_offset) ? 5 : 0;
sleeper_size = (use_full_sleepers) ? 2 : 1;

function DegToRad(degrees) = degrees * pi / 180;
function RadToDeg(radians) = radians * 180 / pi;

function GetCoefficients(x1,y1,x2,y2,k1,k2) = [
    ( x2*(x1*(-x1+x2)*(k2*x1+k1*x2)-x2*(-3*x1+x2)*y1)+pow(x1,2)*(x1-3*x2)*y2 ),        //a0
    ( k2*x1*(x1-x2)*(x1+2*x2)-x2*(k1*(-2*pow(x1,2)+x1*x2+pow(x2,2))+6*x1*(y1-y2)) ),   //a1
    ( -k1*(x1-x2)*(x1+2*x2)+k2*(-2*pow(x1,2)+x1*x2+pow(x2,2))+3*(x1+x2)*(y1-y2) ),     //a2
    ( (k1+k2)*(x1-x2)-2*y1+2*y2 )                                                      //a3
]/ pow((x1-x2),3);

// Parametic function, getting X position: 0<i<1
function GetX(i,offsetR=0) = 
    (TrackAngle==0) ? 
        i*lengthxy :
        abs((track_radius+offsetR)*sin(i*(TrackAngle)));
        
// Parametic function, getting Y position: 0<i<1
function GetY(i,offsetR=0) = 
    (TrackAngle==0) ? 
        0 :
        sign(TrackAngle)*(track_radius-(track_radius+offsetR)*cos(i*-abs(TrackAngle)));

// Functiong getting Z position (or ramp angle): 0<i<1; depending on coefficients used
function GetZ(i,coef=c_heights) =
    coef[3]*pow(i*lengthxy,3) + coef[2]*pow(i*lengthxy,2) + coef[1]*i*lengthxy + coef[0];

// Functiong getting ramp angle: 0<i<1 [deg]
function GetTilt(i,coef=ramp_tilt_angle) =
    (coef[3]*pow(i*lengthxy,3) + coef[2]*pow(i*lengthxy,2) + coef[1]*i*lengthxy + coef[0]) * 180/pi;

// Calculate polynomal coefficients:
c_heights = GetCoefficients(0,0,lengthxy,ramp_height*BrickH,0,0); //[mm]
c_angles = [ c_heights[1], 2*c_heights[2], 3*c_heights[3], 0 ]; //[rad]

//Generate path:
step_size=Unit/lengthxy/2;
path_pts = [for(i=[0:step_size:1+0.1*step_size])  [GetX(i),GetY(i),GetZ(i,c_heights)] ];

//Calculated 3D curve length:
function d(n,step) = sqrt( pow(GetX(n+step)-GetX(n),2) + pow(GetY(n+step)-GetY(n),2) + pow(GetZ(n+step,c_heights)-GetZ(n,c_heights),2)  );
function add_up_to(n=0, step=0.05, sum=0) =
    n>=1 ?
        sum :
        add_up_to(n+step, step, sum+d(n,step));
length3d = add_up_to();


function GenerateSection3D(i,c,d=1,force_no_offset=false) = 
[
    [0,d*TrackFullWidth/2,geo_rail_zoffset],
    [0,d*TrackFullWidth/2,GetZ(i,c)+7.3],
    [0,d*TrackWheelWidth/2,GetZ(i,c)+7.3],
    [0,d*(TrackWheelWidth/2-1.3),GetZ(i,c)+14],
    [0,d*(TrackWheelWidth/2-2.4-geo_rim_thickness_increase),GetZ(i,c)+14],
    [0,d*(TrackWheelWidth/2-2.4-geo_rim_thickness_increase),geo_rail_zoffset],
    [0,d*(TrackWheelWidth/2-2.4-geo_rim_thickness_increase+BrickWallT),geo_rail_zoffset],

    [0,d*(TrackWheelWidth/2-2.4-geo_rim_thickness_increase+BrickWallT),
        force_no_offset
            ? geo_rail_zoffset
            : (geo_use_offset ? geo_rail_zoffset : geo_rail_zoffset+4)],

    [0,d*(TrackFullWidth/2-BrickWallT/2),
        force_no_offset
            ? geo_rail_zoffset
            : (geo_use_offset ? geo_rail_zoffset : geo_rail_zoffset+4)],

    [0,d*(TrackFullWidth/2-BrickWallT/2),geo_rail_zoffset],
    [0,d*TrackFullWidth/2,geo_rail_zoffset]
];


function RotateSection3D(Section, angle=0) =
    [for(j=[0:len(Section)-1])
        rotate_p(
            [Section[j][0],Section[j][1],Section[j][2]],
            angle,
            [0,0,1]
        )
    ];


function MoveSection3D(Section, OffsetX=0,OffsetY=0,OffsetZ=0) =
    [for(j=[0:len(Section)-1])
        [
            Section[j][0]+OffsetX,
            Section[j][1]+OffsetY,
            Section[j][2]+OffsetZ
        ]
    ];


function GetSectionTrackX(
    i,
    c,
    angle,
    dir=1,
    force_no_offset=false
) =
    MoveSection3D(
        RotateSection3D(
            GenerateSection3D(
                i,
                c,
                dir,
                force_no_offset
            ),
            i*angle
        ),
        GetX(i),
        GetY(i),
        0
    );


// BUILDING  TRACK =========================================================================
//GenerateTrack();
        
// Tapered rectangular prism (prismoid)
// top_scale=0.7 means the top is 70% of the bottom size
        
module RibPrismoid(
    bottom_depth=1.8,
    top_depth=0.9,
    width=3.25,
    height=3.5
) {
    polyhedron(
        points=[
            [-bottom_depth/2,-width/2,0],
            [ bottom_depth/2,-width/2,0],
            [ bottom_depth/2, width/2,0],
            [-bottom_depth/2, width/2,0],

            [-top_depth/2,-width/2,height],
            [ top_depth/2,-width/2,height],
            [ top_depth/2, width/2,height],
            [-top_depth/2, width/2,height]
        ],
        faces=[
            [0,1,2,3],
            [4,7,6,5],
            [0,4,5,1],
            [1,5,6,2],
            [2,6,7,3],
            [3,7,4,0]
        ]
    );
}


        

module GenerateBigRibs(posy, width) {
    stepsize=BigRibPitch/length3d;

    for(i=[.5*stepsize:stepsize:1-.5*stepsize]) {
        translate([GetX(i),GetY(i),GetZ(i,c_heights)])
            rotate(i*TrackAngle,[0,0,1])
                translate([0,posy,RibBaseZ])
                    rotate(GetTilt(i,c_angles),[0,-1,0])
                        RibPrismoid(
                            bottom_depth=BigRibBottomDepth,
                            top_depth=BigRibTopDepth,
                            width=width,
                            height=BigRibHeight
                        );
    }
}


module GenerateSmallRibs(posy, width) {
    stepsize=SmallRibPitch/length3d;

    for(i=[.5*stepsize:stepsize:1-.5*stepsize]) {
        translate([GetX(i),GetY(i),GetZ(i,c_heights)])
            rotate(i*TrackAngle,[0,0,1])
                translate([0,posy,RibBaseZ])
                    rotate(GetTilt(i,c_angles),[0,-1,0])
                        cube(
                            [SmallRibDepth,width,SmallRibHeight],
                            center=true
                        );
    }
}

  




module GenerateRail(
    dir=-1,
    force_no_offset=false,
    test_mode=false
) {

    allsections = dir == -1
        ? [
            for(j=[0:len(path_pts)-1])
                GetSectionTrackX(
                    j/(len(path_pts)-1),
                    c_heights,
                    TrackAngle,
                    dir,
                    force_no_offset
                )
          ]
        : [
            for(j=[len(path_pts)-1:-1:0])
                GetSectionTrackX(
                    j/(len(path_pts)-1),
                    c_heights,
                    TrackAngle,
                    dir,
                    force_no_offset
                )
          ];

    // TEST MODE: komplette Rail ohne irgendwelche Abzüge
    if (test_mode) {

        polysections(allsections);

    } else {

        difference() {

            polysections(allsections);

            if (!geo_use_offset) {

                translate([0,0,0])
                    cube([2*Unit-.5,4*Unit,11],center=true);

                if (nr_of_sleepers>0) {
                    for(k=[1:nr_of_sleepers]) {

                        i=k/(nr_of_sleepers+1);

                        translate([GetX(i),GetY(i),-1])
                            rotate(i*TrackAngle,[0,0,1])
                                translate([0,0,StudH/2])
                                    cube([
                                        sleeper_size*(Unit-HorzPlay),
                                        4*(Unit-HorzPlay),
                                        StudH+3
                                    ],center=true);
                    }
                }
            }

            translate([GetX(1),GetY(1),-.5])
                rotate(TrackAngle,[0,0,1])

                if (ramp_extend_support) {

                    GenerateBrick(
                        unitsX=(2*Unit-1)/Unit,
                        unitsY=4,
                        unitsZ=(GetZ(1,c_heights)-1)/BrickH,
                        angle_deg=GetTilt(1,c_angles),
                        hasKnobs=false,
                        hasStuds=false
                    );

                } else {

                    GenerateBrick(
                        unitsX=(2*Unit-1)/Unit,
                        unitsY=4,
                        unitsZ=(GetZ(1,c_heights)+6)/BrickH,
                        angle_deg=GetTilt(1,c_angles),
                        hasKnobs=false,
                        hasStuds=false
                    );
                }
        }
    }
}

module GenerateTrack(){

    // Test mode: only rail + BigRibs
    if (test_bigribs_only) {

        GenerateRail(1,true,true);
        GenerateRail(-1,true,true);

        rib_width = BigRibWidth;
            //(TrackFullWidth - TrackWheelWidth) / 2 / 3.5;

        GenerateBigRibs(
            posy=-(TrackFullWidth-rib_width)/2,
            width=rib_width
        );

        GenerateBigRibs(
            posy=(TrackFullWidth-rib_width)/2,
            width=rib_width
        );
    }

    else {

        // Start track end
        GenerateTrainTrackEnd();

        // Rails
        GenerateRail(1);
        GenerateRail(-1);

        // End track
        translate([GetX(1),GetY(1),GetZ(0)])
            rotate(TrackAngle+180,[0,0,1])
            if (ramp_extend_support) { 
                GenerateBrick(
                    unitsX=2,
                    unitsY=4,
                    unitsZ=(GetZ(1-step_size/2))/BrickH,
                    angle_deg=0,
                    hasKnobs=false,
                    hasStuds=true
                );

                translate([-Unit/2,0,0])
                    GenerateKnobs(
                        unitsX=1,
                        unitsY=4,
                        unitsZ=(GetZ(1-step_size/2))/BrickH
                    );
            }
            else {
                translate([0,0,GetZ(1)])
                    GenerateTrainTrackEnd();
            }

        // Sleepers
        if (nr_of_sleepers>0){
            for(k=[1:nr_of_sleepers]){ 
                i=k/(nr_of_sleepers+1);

                translate([GetX(i),GetY(i),0])
                    rotate(i*TrackAngle,[0,0,1])
                        GenerateStuds(
                            unitsX=sleeper_size,
                            unitsY=4
                        );
            }
        }

        // Big ribs
        if (geo_use_bigribs) {

            rib_width = BigRibWidth;
                //(TrackFullWidth - TrackWheelWidth) / 2 / 3.5;

            GenerateBigRibs(
                posy=-(TrackFullWidth-rib_width)/2,
                width=rib_width
            );

            GenerateBigRibs(
                posy=(TrackFullWidth-rib_width)/2,
                width=rib_width
            );
        }

        // Small ribs
        if (geo_use_smallribs) {

            rib_width =
                (TrackFullWidth - TrackWheelWidth) / 2;

            if (TrackAngle>=0)
                GenerateSmallRibs(
                    posy=(TrackFullWidth-rib_width)/2,
                    width=rib_width
                );

            if (TrackAngle<=0)
                GenerateSmallRibs(
                    posy=-(TrackFullWidth-rib_width)/2,
                    width=rib_width
                );
        }
    }
}

function __to2d(p) = [p[0], p[1]];
function __to3d(p) = [p[0], p[1], 0];
function __to_3_elems_ang_vect(a) =
     let(leng = len(a))
     leng == 3 ? a : (
         leng == 2 ? [a[0], a[1], 0] :  [a[0], 0, 0]
     );

function __to_ang_vect(a) = is_num(a) ? [0, 0, a] : __to_3_elems_ang_vect(a);

function _q_rotate_p_3d(p, a, v) = 
    let(
        half_a = a / 2,
        axis = v / norm(v),
        s = sin(half_a),
        x = s * axis[0],
        y = s * axis[1],
        z = s * axis[2],
        w = cos(half_a),
        
        x2 = x + x,
        y2 = y + y,
        z2 = z + z,

        xx = x * x2,
        yx = y * x2,
        yy = y * y2,
        zx = z * x2,
        zy = z * y2,
        zz = z * z2,
        wx = w * x2,
        wy = w * y2,
        wz = w * z2        
    )
    [
        [1 - yy - zz, yx - wz, zx + wy] * p,
        [yx + wz, 1 - xx - zz, zy - wx] * p,
        [zx - wy, zy + wx, 1 - xx - yy] * p
    ];

function _rotx(pt, a) = 
    a == 0 ? pt :
    let(cosa = cos(a), sina = sin(a))
    [
        pt[0], 
        pt[1] * cosa - pt[2] * sina,
        pt[1] * sina + pt[2] * cosa
    ];

function _roty(pt, a) = 
    a == 0 ? pt :
    let(cosa = cos(a), sina = sin(a))
    [
        pt[0] * cosa + pt[2] * sina, 
        pt[1],
        -pt[0] * sina + pt[2] * cosa, 
    ];

function _rotz(pt, a) = 
    a == 0 ? pt :
    let(cosa = cos(a), sina = sin(a))
    [
        pt[0] * cosa - pt[1] * sina,
        pt[0] * sina + pt[1] * cosa,
        pt[2]
    ];

function _rotate_p_3d(point, a) =
    _rotz(_roty(_rotx(point, a[0]), a[1]), a[2]);

function _rotate_p(p, a) =
    let(angle = __to_ang_vect(a))
    len(p) == 3 ? 
        _rotate_p_3d(p, angle) :
        __to2d(
            _rotate_p_3d(__to3d(p), angle)
        );


function _q_rotate_p(p, a, v) =
    len(p) == 3 ? 
        _q_rotate_p_3d(p, a, v) :
        __to2d(
            _q_rotate_p_3d(__to3d(p), a, v)
        );

function rotate_p(point, a, v) =
    is_undef(v) ? _rotate_p(point, a) : _q_rotate_p(point, a, v);

module polysections(sections, triangles = "SOLID") {

    function side_indexes(sects, begin_idx = 0) = 
        let(       
            leng_sects = len(sects),
            leng_pts_sect = len(sects[0]),
            range_j = [begin_idx:leng_pts_sect:begin_idx + (leng_sects - 2) * leng_pts_sect],
            range_i = [0:leng_pts_sect - 1]
        ) 
        concat(
            [
                for(j = range_j)
                    for(i = range_i) 
                        [
                            j + i, 
                            j + (i + 1) % leng_pts_sect, 
                            j + (i + 1) % leng_pts_sect + leng_pts_sect
                        ]
            ],
            [
                for(j = range_j)
                    for(i = range_i) 
                        [
                            j + i, 
                            j + (i + 1) % leng_pts_sect + leng_pts_sect , 
                            j + i + leng_pts_sect
                        ]
            ]      
        );

    function search_at(f_sect, p, leng_pts_sect, i = 0) =  
        i < leng_pts_sect ?
            (p == f_sect[i] ? i : search_at(f_sect, p, leng_pts_sect, i + 1)) : -1;
    
    function the_same_after_twisting(f_sect, l_sect, leng_pts_sect) =
        let(
            found_at_i = search_at(f_sect, l_sect[0], leng_pts_sect)
        )
        found_at_i <= 0 ? false : 
            l_sect == concat(
                [for(i = [found_at_i:leng_pts_sect-1]) f_sect[i]],
                [for(i = [0:found_at_i-1]) f_sect[i]]
            ); 

    function to_v_pts(sects) = 
            [
            for(sect = sects) 
                for(pt = sect) 
                    pt
            ];                   

    module solid_sections(sects) {
        
        leng_sects = len(sects);
        leng_pts_sect = len(sects[0]);
        first_sect = sects[0];
        last_sect = sects[leng_sects - 1];
   
        v_pts = [
            for(sect = sects) 
                for(pt = sect) 
                    pt
        ];

        begin_end_the_same =
            first_sect == last_sect || 
            the_same_after_twisting(first_sect, last_sect, leng_pts_sect);

        if(begin_end_the_same) {
            f_idxes = side_indexes(sects);

            polyhedron(
                v_pts, 
                f_idxes,
                10
            ); 
        } else {
            range_i = [0:leng_pts_sect - 1];
            first_idxes = [for(i = range_i) leng_pts_sect - 1 - i];  
            last_idxes = [
                for(i = range_i) 
                    i + leng_pts_sect * (leng_sects - 1)
            ];    

            f_idxes = concat([first_idxes], side_indexes(sects), [last_idxes]);
            
            polyhedron(
                v_pts, 
                f_idxes,
                10
            );
        }
    }

    module hollow_sections(sects) {
        leng_sects = len(sects);
        leng_sect = len(sects[0]);
        half_leng_sect = leng_sect / 2;
        half_leng_v_pts = leng_sects * half_leng_sect;

        function strip_sects(begin_idx, end_idx) = 
            [
                for(i = [0:leng_sects-1]) 
                    [
                        for(j = [begin_idx:end_idx])
                            sects[i][j]
                    ]
            ]; 

        function first_idxes() = 
            [
                for(i = [0:half_leng_sect - 1]) 
                    [
                       i,
                       i + half_leng_v_pts,
                       (i + 1) % half_leng_sect + half_leng_v_pts, 
                       (i + 1) % half_leng_sect
                    ] 
            ];

        function last_idxes(begin_idx) = 
            [
                for(i = [0:half_leng_sect-1]) 
                    [
                       begin_idx + i,
                       begin_idx + (i + 1) % half_leng_sect,
                       begin_idx + (i + 1) % half_leng_sect + half_leng_v_pts,
                       begin_idx + i + half_leng_v_pts
                    ]     
            ];            

        outer_sects = strip_sects(0, half_leng_sect - 1);
        inner_sects = strip_sects(half_leng_sect, leng_sect - 1);

        outer_v_pts =  to_v_pts(outer_sects);
        inner_v_pts = to_v_pts(inner_sects);

        outer_idxes = side_indexes(outer_sects);
        inner_idxes = [ 
            for(idxes = side_indexes(inner_sects, half_leng_v_pts))
                __reverse(idxes)
        ];

        first_outer_sect = outer_sects[0];
        last_outer_sect = outer_sects[leng_sects - 1];
        first_inner_sect = inner_sects[0];
        last_inner_sect = inner_sects[leng_sects - 1];
        
        leng_pts_sect = len(first_outer_sect);

        begin_end_the_same = 
           (first_outer_sect == last_outer_sect && first_inner_sect == last_inner_sect) ||
           (
               the_same_after_twisting(first_outer_sect, last_outer_sect, leng_pts_sect) && 
               the_same_after_twisting(first_inner_sect, last_inner_sect, leng_pts_sect)
           ); 

        v_pts = concat(outer_v_pts, inner_v_pts);

        if(begin_end_the_same) {
            f_idxes = concat(outer_idxes, inner_idxes);

            polyhedron(
                v_pts,
                f_idxes,
                10
            );          
        } else {
            first_idxes = first_idxes();
            last_idxes = last_idxes(half_leng_v_pts - half_leng_sect);

            f_idxes = concat(first_idxes, outer_idxes, inner_idxes, last_idxes);
            
            polyhedron(
                v_pts,
                f_idxes,
                10
            );       
        }
    }
    
    module triangles_defined_sections() {
        module tri_sections(tri1, tri2) {
            hull() polyhedron(
                points = concat(tri1, tri2),
                faces = [
                    [0, 1, 2], 
                    [3, 5, 4], 
                    [1, 3, 4], [2, 1, 4], [2, 3, 0], 
                    [0, 3, 1], [2, 4, 5], [2, 5, 3]
                ],
                10
            );  
        }

        module two_sections(section1, section2) {
            for(idx = triangles) {
               tri_sections(
                    [
                        section1[idx[0]], 
                        section1[idx[1]], 
                        section1[idx[2]]
                    ], 
                    [
                        section2[idx[0]], 
                        section2[idx[1]], 
                        section2[idx[2]]
                    ]
                );
            }
        }
        
        for(i = [0:len(sections) - 2]) {
             two_sections(
                 sections[i], 
                 sections[i + 1]
             );
        }
    }
    
    if(triangles == "SOLID") {
        solid_sections(sections);
    } else if(triangles == "HOLLOW") {
        hollow_sections(sections);
    }
    else {
        triangles_defined_sections();
    }
}