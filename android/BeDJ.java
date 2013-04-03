package com.symplexum.beDJ;

import com.domain.beDJ.R;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

public class BeDJ extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        startLogin();
    }
   
   public void startLogin() 
   {
    	 Intent loginIntent= new Intent(BeDJ.this, LoginActivity.class);
         startActivity(loginIntent);
         finish();
    }
    
}