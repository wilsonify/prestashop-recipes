{extends file='page.tpl'}

{block name='page_content_container'}
  <section id="content" class="page-home">
    {block name='page_content_top'}{/block}

    {block name='page_content'}
      {block name='hook_home'}
        {literal}{$HOOK_HOME}{/literal}
        <div class="row text-center">
            <h2 class="home-welcome">
                Welcome To Havana Classic Car Tours (HCCT)
            </h2>

            <p class="home-text">
                Today <span class="blue-text">Havana</span> is still a mysterious tropical paradise.
                More than 50 years of isolation from the rest of the world has forced the city to
                seem frozen in time. When people visit Havana, they feel as if they have traveled
                back in time to the 40s or 50s. This marvelous journey will be unforgettable when
                you take a ride in a <span class="blue-text">Classic American Car</span>.
            </p>

            <p class="home-text">
                We will be instrumental in transporting you back in time for this once-in-a-lifetime
                <span class="blue-text">AMAZING EXPERIENCE!!!</span>
            </p>

            <div class="content_scene_cat img-divisor"></div>
            <img alt="Classic Car" src="{$img_dir}front-car.png" />

            <p class="home-text home-list">
                <img alt="Checkmark" src="{$img_dir}icon/form-ok.png" />  
                We have predesigned <span class="blue-text">City Tours</span> based on our 
                <span class="blue-text">Local Knowledge</span> of the city and its most popular 
                attractions. Our service can be flexible if you have specific requests 
                (additional charges may apply - ask your driver).
            </p>

            <p class="home-text home-list">
                <img alt="Checkmark" src="{$img_dir}icon/form-ok.png" />  
                Pick-up can be arranged at almost any location in Havana, including hotels, private 
                houses (Casa Particular), restaurants, or paladars. Just 
                <span class="blue-text">provide a specific and complete address</span> when booking 
                your tour.
            </p>

            <p class="home-text home-list">
                <img alt="Checkmark" src="{$img_dir}icon/form-ok.png" />  
                A <span class="blue-text">Guided Tour Service</span> in English is also available. 
                Your driver is knowledgeable and may offer a limited guide service in SPANGLISH, 
                but he will be focused on driving, meaning some tour details may be missed. 
                Please select this service when booking your tour.
            </p>
        </div>
      {/block}
    {/block}
  </section>
{/block}
