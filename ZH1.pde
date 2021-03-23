int bgColor = 204;
int felatloXStart;
int felatloYStart;

int countClicks = 0;
int prevMouseX, prevMouseY;

Table table, table2;
boolean redraw = false;

boolean inputMod = false;
boolean vag = false;
final int BENT = 0;    // 0000
final int BAL  = 1;    // 0001
final int JOBB = 2;    // 0010
final int LENT = 4;    // 0100
final int FENT = 8;    // 1000

int cutXMin = 0;
int cutYMin = 0;
int cutXMax = 0;
int cutYMax = 0;

void setup() {
    size(640, 480);

    felatloXStart = width /5;
    felatloYStart = height /5;
    
    table = new Table();    
    table.addColumn("x");
    table.addColumn("y");
    
    table2 = loadTable("modell.csv", "header");
    /* modell.csv pelda:
    x1,y1,x2,y2
    50,50,400,75
    350,50,200,300
    200,100,500,400
    */
}

void draw() {
    if (redraw) {
        background(bgColor);
    }
    if (inputMod) {
        for (TableRow row : table2.rows()) {
            int x1 = row.getInt("x1");    
            int y1 = row.getInt("x2");
            int x2 = row.getInt("y1");
            int y2 = row.getInt("y2");            
            if (vag) {
                CohenSutherlandSzakaszvago(x1,y1,x2,y2);
            } else {
                drawLine(x1,y1,x2,y2);
            } 
        }
    } else {
        if (vag) {
            CohenSutherlandSzakaszvago(felatloXStart, felatloYStart, felatloXStart+felatloSzelesseg(), felatloYStart+felatloMagassag());
        } else {
            drawLine(felatloXStart, felatloYStart, felatloXStart+felatloSzelesseg(), felatloYStart+felatloMagassag());
        }   
    
        if (table.getRowCount() > 1) {
            if (redraw) {      
                background(204);
                
                int x0 = table.getRow(0).getInt("x");
                int y0 = table.getRow(0).getInt("y");
        
                int x = table.getRow(1).getInt("x");
                int y = table.getRow(1).getInt("y");
        
                drawHex(x, y, x0, y0);            
                redraw = false;
            }        
        }
    }
}

int felatloHossza() {
    return (int) sqrt(pow(width, 2) + pow(height, 2)) / 2;
}

int felatloSzelesseg() {    
    return width/2 + 10;
}

int felatloMagassag() {
    return height/2 + 10;
}

void drawLine(float x, float y, float x0, float y0) {
    float m;
    float i, j;

    if (x0 != x) { // nem függőleges
        m = (y0 - y) / (x0 - x);

        if (abs(m) <= 1) {
            j = (x < x0) ? y : y0;
            for (i = (x < x0) ? x : x0; i < ((x > x0) ? x : x0); i++) {
                point(i, j);
                j += m;
            }
        } else {
            i = (y < y0) ? x : x0;
            for (j = (y < y0) ? y : y0; j < ((y > y0) ? y : y0); j++) {
                point(i, j);
                i += 1/m;
            }
        }
    } else {    // függőleges
        for (j = (y < y0) ? y : y0; j < ((y > y0) ? y : y0); j++) {
            point(x, j);
        }
    }
}

void drawHex(int x1, int y1, int centerX, int centerY) {    
    int x2, y2, x3, y3, x4, y4, x5, y5, x6, y6;
    
    x2 = (int)(x1 + centerX + sqrt(3) * (centerY - y1) ) / 2;
    y2 = (int)(y1 + centerY + sqrt(3) * (x1 - centerX) ) / 2;    
    x3 = (int)(x2 + centerX + sqrt(3) * (centerY - y2) ) / 2;
    y3 = (int)(y2 + centerY + sqrt(3) * (x2 - centerX) ) / 2;    
    x4 = (int)(x3 + centerX + sqrt(3) * (centerY - y3) ) / 2;
    y4 = (int)(y3 + centerY + sqrt(3) * (x3 - centerX) ) / 2;    
    x5 = (int)(x4 + centerX + sqrt(3) * (centerY - y4) ) / 2;
    y5 = (int)(y4 + centerY + sqrt(3) * (x4 - centerX) ) / 2;    
    x6 = (int)(x5 + centerX + sqrt(3) * (centerY - y5) ) / 2;
    y6 = (int)(y5 + centerY + sqrt(3) * (x5 - centerX) ) / 2;
    
    if (vag) {
        CohenSutherlandSzakaszvago(x2, y2, x1, y1);
        CohenSutherlandSzakaszvago(x3, y3, x2, y2);
        CohenSutherlandSzakaszvago(x4, y4, x3, y3);
        CohenSutherlandSzakaszvago(x5, y5, x4, y4);
        CohenSutherlandSzakaszvago(x6, y6, x5, y5);
        CohenSutherlandSzakaszvago(x1, y1, x6, y6);
    } else {    
        drawLine(x2, y2, x1, y1);
        drawLine(x3, y3, x2, y2);
        drawLine(x4, y4, x3, y3);
        drawLine(x5, y5, x4, y4);
        drawLine(x6, y6, x5, y5);
        drawLine(x1, y1, x6, y6);
    }
}

int Zona(double x, double y) {
    int zona = BENT;    

    if (x < cutXMin) zona |= BAL;
    else if (x > cutXMax) zona |= JOBB;
    if (y < cutYMin) zona |= LENT;
    else if (y > cutYMax) zona |= FENT;

    return zona;
}

void CohenSutherlandSzakaszvago(float x0, float y0, float x1, float y1) {
    int pont1Zona = Zona(x0, y0);
    int pont2Zona = Zona(x1, y1);
    boolean elfogad = false;
    boolean vege = false;
    
    do {
        if ((pont1Zona | pont2Zona) == 0) {            
            // mindket pont bent van            
            elfogad = true;
            vege = true;            
        } else {
            if ((pont1Zona & pont2Zona) != 0) {
                // mindket pont kozos kulso zonaban van (BAL, JOBB, FENT, LENT)
                // nem fogadjuk el, vege
                vege = true;
            } else {
                float x = 0, y = 0;
                
                // egy pont biztosan kint van
                int pontKint = pont2Zona > pont1Zona ? pont2Zona : pont1Zona;
    
                if ((pontKint & FENT) != 0) {
                    x = x0 + (x1 - x0) * (cutYMax - y0) / (y1 - y0);
                    y = cutYMax;
                } else if ((pontKint & LENT) != 0) {
                    x = x0 + (x1 - x0) * (cutYMin - y0) / (y1 - y0);
                    y = cutYMin;
                } else if ((pontKint & JOBB) != 0) {
                    y = y0 + (y1 - y0) * (cutXMax - x0) / (x1 - x0);
                    x = cutXMax;
                } else if ((pontKint & BAL) != 0) {
                    y = y0 + (y1 - y0) * (cutXMin - x0) / (x1 - x0);
                    x = cutXMin;
                }
    
                if (pontKint == pont1Zona) {
                    x0 = x;
                    y0 = y;
                    pont1Zona = Zona(x0, y0);
                } else {
                    x1 = x;
                    y1 = y;
                    pont2Zona = Zona(x1, y1);
                }            
            }
        }
    }
    while (!vege);
    
    if (elfogad)
        drawLine(x0, y0, x1, y1);
}

void mousePressed() {
    redraw = true;
    
    if (vag) {
        if (countClicks % 2 == 0) {
            cutXMin = mouseX;
            cutYMin = mouseY;
        } else {
            cutXMax = mouseX;
            cutYMax = mouseY;
        }
        countClicks++;
    }
    else {
        if (table.getRowCount() == 2) {
            table.clearRows();
        }
        TableRow newRow = table.addRow();    
        newRow.setInt("x", mouseX);
        newRow.setInt("y", mouseY);
    }
}

void keyPressed() {
    if (key == 'a') {
        inputMod = !inputMod;
        redraw = true;
    }
    
    if (key == 'b') {
        vag = !vag;       
    }
}
