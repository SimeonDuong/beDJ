package com.symplexum.beDJ;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONObject;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.domain.beDJ.R;

public class LoginActivity extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login);
    
        Button loginButton = (Button)findViewById(R.id.loginButton);
        loginButton.setOnClickListener(new View.OnClickListener() {

          @Override
          public void onClick(View view) {
        	  String result="";
           //Check username and password   
              try{
                  JSONObject jObject = new JSONObject();
                  jObject.put("username","questir5");
                  jObject.put("password","Symplexum1!");
                  jObject.put("user",((EditText)findViewById(R.id.editText1)).getText().toString());
                  jObject.put("pass",((EditText)findViewById(R.id.editText2)).getText().toString());
                  StringEntity se= new StringEntity(jObject.toString());
                  System.out.print(jObject.toString());
         
      		HttpClient httpclient = new DefaultHttpClient();
      		HttpPost httppost = new HttpPost("http://questionforanswer.com/logincheck.php");
      		httppost.setEntity(se);
                  		
      		HttpResponse response = httpclient.execute(httppost);
      		HttpEntity entity= response.getEntity();
      		InputStream is = entity.getContent();
      		
      		
          BufferedReader reader = new BufferedReader(new InputStreamReader(is),8);
          StringBuilder sb = new StringBuilder();
          String line = null;
          
          while ((line = reader.readLine()) != null) {
                  sb.append(line);
          }
          is.close();
              
          result=sb.toString();
          
           }
      catch(Exception e){
          Log.e("log_tag", "Error converting result "+e.toString());
  }
           if(result.equals("SuccessfulLogin"))
              {    
           Intent loginIntent= new Intent(LoginActivity.this, OverviewActivity.class);
           startActivity(loginIntent);
           finish();
           Toast.makeText(getApplicationContext(), "Login Success", Toast.LENGTH_SHORT).show();
              }
           else
           {
        	   Toast.makeText(getApplicationContext(), "Failed Login", Toast.LENGTH_SHORT).show(); 
           }
          }
    });
        
   // Listener for CreateNewUser
        
        Button newloginButton = (Button)findViewById(R.id.newuserbutton);
        newloginButton.setOnClickListener(new View.OnClickListener() {
          @Override
          //Button to launch new dialog;
          public void onClick(View view) {
        	  Dialog dialog = new Dialog(LoginActivity.this);
        	  
        	  dialog.setContentView(R.layout.newlogin_popup);

        	  WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
        	    lp.copyFrom(dialog.getWindow().getAttributes());
        	    lp.width = WindowManager.LayoutParams.FILL_PARENT;
        	    lp.height = WindowManager.LayoutParams.FILL_PARENT;
          
        	  dialog.setTitle("Create new user");
        	  dialog.show();
        	  dialog.getWindow().setAttributes(lp);
        	  Button createNewUserButton = (Button)dialog.findViewById(R.id.createNewUserButton);
        	  
        	  createNewUserButton.setOnClickListener(new View.OnClickListener() {
                 //button to launch Internet connection
        		  @Override
                      public void onClick(View v) {
        			  if(((EditText)((View)v.getParent()).findViewById(R.id.newpass)).getText().toString().equals(((EditText)((View)v.getParent()).findViewById(R.id.newpassconfirm)).getText().toString()))
        			  {String result="";
        	         
        	          //Check username and password   
        	              try{
        	                  JSONObject jObject = new JSONObject();
        	                  jObject.put("username","questir5");
        	                  jObject.put("password","Symplexum1!");
        	                  jObject.put("newuser",((EditText)((View)v.getParent()).findViewById(R.id.newuser)).getText().toString());
        	                  jObject.put("newpass",((EditText)((View)v.getParent()).findViewById(R.id.newpass)).getText().toString());
        	                  StringEntity se= new StringEntity(jObject.toString());
        	                  
        	      		HttpClient httpclient = new DefaultHttpClient();
        	      		HttpPost httppost = new HttpPost("http://questionforanswer.com/accountcreationUserTable.php");
        	      		httppost.setEntity(se);
        	                  		
        	      		HttpResponse response = httpclient.execute(httppost);
        	      		HttpEntity entity= response.getEntity();
        	      		InputStream is = entity.getContent();
        	      		
        	      		
        	          BufferedReader reader = new BufferedReader(new InputStreamReader(is),8);
        	          StringBuilder sb = new StringBuilder();
        	          String line = null;
        	          
        	          while ((line = reader.readLine()) != null) {
        	                  sb.append(line);
        	          }
        	          is.close();
        	              
        	          result=sb.toString();
        	                  	           }
        	              
        	      catch(Exception e){
        	          Log.e("log_tag", "Error converting result "+e.toString());
        	  }
        	              System.out.println("a" + result + ((EditText)((View)v.getParent()).findViewById(R.id.newuser)).getText().toString());
        	              
        	              if(result.equals("AccountCreated"))
        	            	  {Toast.makeText(getApplicationContext(), "User created. Welcome to beDJ!", Toast.LENGTH_SHORT).show();
        	            	  
        	            	  Intent loginIntent= new Intent(LoginActivity.this, OverviewActivity.class);
        	                  startActivity(loginIntent);
        	                  finish();
        	            	  } 
        	            	  
        	              else if(result.equals("That username is already taken."))
        				  Toast.makeText(getApplicationContext(),(CharSequence)result, Toast.LENGTH_SHORT).show();
        	              
        	              else
        	            	  Toast.makeText(getApplicationContext(), (CharSequence)result, Toast.LENGTH_SHORT).show();
        			    
                      }
        			  else
        	  Toast.makeText(getApplicationContext(), "Passwords must match", Toast.LENGTH_SHORT).show();
        		  }
        		  
                  });
        	  
            }
          
        
    
    
    });
    }
}

