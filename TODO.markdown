# To do

- Do you need to add the postmark config to config/environments/production.rb?
- What is the postmark account? You couldn't find it before
- Put it on prod! Just still sending only to us. With a daily send.
- Put some tests in for next game released (email text)
- Fix that deprecation warning on the pod admin tests
- Check lato is actually on in that email

Test to look at:

      it "should say what the next game to be released will be" do
        expect(page).to have_content("next game released will be Game 2")
      end


Before merging:

- Look through all the commits in this branch before merging
- Send the first batch only to hello@easypeasy and bsafwat@gmail and check before sending out for real
- So send out manually for the first week or two

Later:

- Allow pod admins to delete comments
